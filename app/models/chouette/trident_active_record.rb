class Chouette::TridentActiveRecord < Chouette::ActiveRecord
  include StifNetexAttributesSupport

  self.abstract_class = true

  def referential
    @referential ||= Referential.where(:slug => Apartment::Tenant.current).first!
  end

  def hub_restricted?
    referential.data_format == "hub"
  end

  def prefix
    referential.prefix
  end

end
