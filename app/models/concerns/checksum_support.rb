module ChecksumSupport
  extend ActiveSupport::Concern
  SEPARATOR = '|'
  VALUE_FOR_NIL_ATTRIBUTE = '-'

  included do
    before_save :set_current_checksum_source, :update_checksum
  end

  def checksum_attributes
    self.attributes.values
  end

  def checksum_replace_nil_or_empty_values values
    # Replace empty array by nil & nil by VALUE_FOR_NIL_ATTRIBUTE
    values.map{ |x| x unless x.try(:empty?) }.map{ |x| x || VALUE_FOR_NIL_ATTRIBUTE }.map do |item|
      item = item.kind_of?(Array) ? checksum_replace_nil_or_empty_values(item) : item
    end
  end

  def current_checksum_source
    source = checksum_replace_nil_or_empty_values(self.checksum_attributes)
    source.map{ |item|
      item = item.kind_of?(Array) ? item.map{ |x| "(#{x.join(',')})"}.join(',') : item
    }.join(SEPARATOR)
  end

  def set_current_checksum_source
    self.checksum_source = self.current_checksum_source
  end

  def update_checksum
    if self.checksum_source_changed?
      self.checksum = Digest::SHA256.new.hexdigest(self.checksum_source)
    end
  end
end
