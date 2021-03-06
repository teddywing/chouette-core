module ChecksumSupport
  extend ActiveSupport::Concern
  SEPARATOR = '|'
  VALUE_FOR_NIL_ATTRIBUTE = '-'

  included do |into|
    before_save :set_current_checksum_source, :update_checksum
    Referential.register_model_with_checksum self
    into.extend ClassMethods
  end

  module ClassMethods

    def has_checksum_children klass, opts={}
      parent_class = self
      belongs_to = opts[:relation] || self.model_name.singular
      has_many = opts[:relation] || self.model_name.plural

      Rails.logger.debug "Define callback in #{klass} to update checksums #{self.model_name} (via #{has_many}/#{belongs_to})"

      child_update_parent = Proc.new do
        parents = []
        parents << self.send(belongs_to) if klass.reflections[belongs_to].present?
        parents += self.send(has_many) if klass.reflections[has_many].present?
        Rails.logger.debug "Request from #{klass.name} checksum updates for #{parents.count} #{parent_class} parent(s)"
        parents.compact.each &:update_checksum_without_callbacks!
      end

      klass.after_save &child_update_parent
      klass.after_destroy &child_update_parent
    end
  end

  def checksum_attributes
    self.attributes.values
  end

  def checksum_replace_nil_or_empty_values values
    # Replace empty array by nil & nil by VALUE_FOR_NIL_ATTRIBUTE
    values
      .map { |x| x.present? && x || VALUE_FOR_NIL_ATTRIBUTE }
      .map do |item|
        item =
          if item.kind_of?(Array)
            checksum_replace_nil_or_empty_values(item)
          else
            item
          end
      end
  end

  def current_checksum_source
    source = checksum_replace_nil_or_empty_values(self.checksum_attributes)
    source += self.custom_fields_checksum if self.respond_to?(:custom_fields_checksum)
    source.map{ |item|
      if item.kind_of?(Array)
        item.map{ |x| x.kind_of?(Array) ? "(#{x.join(',')})" : x }.join(',')
      else
        item
      end
    }.join(SEPARATOR)
  end

  def set_current_checksum_source
    self.checksum_source = self.current_checksum_source
  end

  def update_checksum
    if self.checksum_source_changed?
      self.checksum = Digest::SHA256.new.hexdigest(self.checksum_source)
      Rails.logger.debug("Changed #{self.class.name}:#{id} checksum: #{self.checksum}")
    end
  end

  def update_checksum!
    _checksum_source = current_checksum_source
    update checksum_source: _checksum_source, checksum: Digest::SHA256.new.hexdigest(_checksum_source)
    Rails.logger.debug("Updated #{self.class.name}:#{id} checksum: #{self.checksum}")
  end

  def update_checksum_without_callbacks!
    set_current_checksum_source
    _checksum = Digest::SHA256.new.hexdigest(checksum_source)
    Rails.logger.debug("Compute checksum for #{self.class.name}:#{id} checksum_source:'#{checksum_source}' checksum: #{_checksum}")
    if _checksum != self.checksum
      self.checksum = _checksum
      self.class.where(id: self.id).update_all(checksum: _checksum, checksum_source: checksum_source) unless self.new_record?
      Rails.logger.debug("Updated #{self.class.name}:#{id} checksum: #{self.checksum}")
    end
  end
end
