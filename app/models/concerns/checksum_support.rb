module ChecksumSupport
  extend ActiveSupport::Concern
  SEPARATOR = '|'
  VALUE_FOR_NIL_ATTRIBUTE = '-'

  included do
    before_save :set_current_checksum_source, :update_checksum
    Referential.register_model_with_checksum self
  end

  def checksum_attributes
    self.attributes.values
  end

  def current_checksum_source
    source = self.checksum_attributes.map{ |x| x unless x.try(:empty?) }
    source = source.map{ |x| x || VALUE_FOR_NIL_ATTRIBUTE }
    source.map(&:to_s).join(SEPARATOR)
  end

  def set_current_checksum_source
    self.checksum_source = self.current_checksum_source
  end

  def update_checksum
    if self.checksum_source_changed?
      self.checksum = Digest::SHA256.new.hexdigest(self.checksum_source)
    end
  end

  def update_checksum!
    set_current_checksum_source
    if checksum_source_changed?
      update checksum: Digest::SHA256.new.hexdigest(checksum_source)
    end
  end
end
