class Chouette::ObjectidFormatter::Netex
  def before_validation(model)
    model.update_attributes(objectid: Chouette::Objectid::Netex.new(local_id: SecureRandom.uuid, object_type: model.class.name.gsub(/Chouette::/,'')).to_s) unless model.read_attribute(:objectid)
  end

  def after_commit(model)
    # unused method in this context
  end

  def get_objectid(definition)
    parts = definition.try(:split, ":")
    Chouette::Objectid::Netex.new(provider_id: parts[0], object_type: parts[1], local_id: parts[2], creation_id: parts[3]) rescue nil
  end
end