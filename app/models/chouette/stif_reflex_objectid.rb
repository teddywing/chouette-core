class Chouette::StifReflexObjectid < String

  @@format = /^([A-Za-z_]+):([0-9A-Za-z_-]+):([A-Za-z]+):([0-9A-Za-z_-]+):([A-Za-z]+)$/
  cattr_reader :format

  def parts
    match(format).try(:captures)
  end

  def object_type
    parts.try(:third)
  end

  def local_id
    parts.try(:fourth)
  end

end
