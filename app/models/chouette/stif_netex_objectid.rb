class Chouette::StifNetexObjectid < String
  def valid?
    parts.present?
  end

  @@format = /^([A-Za-z_]+):([A-Za-z]+):([0-9A-Za-z_-]+):([A-Za-z]+)$/
  cattr_reader :format

  def parts
    match(format).try(:captures)
  end

  def provider_id
    parts.try(:first)
  end

  def object_type
    parts.try(:second)
  end

  def local_id
    parts.try(:third)
  end

  def boiv_id
    parts.try(:fourth)
  end

  def short_id
    local_id.try(:split, "-").try(:[], -1)
  end

  def self.create(provider_id, object_type, local_id, boiv_id)
    new [provider_id, object_type, local_id, boiv_id].join(":")
  end

  def self.new(string)
    string ||= ""
    self === string ? string : super
  end

end
