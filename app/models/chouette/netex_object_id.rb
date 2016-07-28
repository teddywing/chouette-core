class Chouette::NetexObjectId < String

  def valid?
    parts.present?
  end
  alias_method :objectid?, :valid?

  @@format = /^([A-Za-z_]+):([0-9A-Za-z_]+):([A-Za-z]+):([0-9A-Za-z_-]+)$/ 
  cattr_reader :format

  def parts
    match(format).try(:captures)
  end

  def provider_id
    parts.try(:first)
  end

  def system_id
    parts.try(:second)
  end

  def object_type
    parts.try(:third)
  end

  def local_id
    parts.try(:fourth)
  end
  
  def self.create(provider_id, system_id, object_type, local_id)
    new [provider_id, system_id, object_type, local_id].join(":")
  end

  def self.new(string)
    string ||= ""
    self === string ? string : super
  end

end
