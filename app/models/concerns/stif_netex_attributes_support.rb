module StifNetexAttributesSupport
  extend ActiveSupport::Concern

  included do

    validates_presence_of :objectid
    validates :objectid, uniqueness: true
    validates_numericality_of :object_version
    validate :objectid_format_compliance

    before_validation :default_values, :on => :create
    # before_save :increment_workbench_local_id
  end

  def objectid
    Chouette::StifNetexObjectid.new read_attribute(:objectid)
  end

  def provider_id
    self.referential.workbench.organisation
  end

  def object_type
    self.class
  end


  def local_id
    ''
  end

  def boiv_id
    'LOC'
  end

  def objectid_format_compliance
    errors.add :objectid, I18n.t("activerecord.errors.models.stif_netex.invalid_object_id") if !objectid.valid?
  end

  def default_values
    self.object_id ||= Chouette::StifNetexObjectId.create(provider_id, object_type, local_id, boiv_id)
    self.object_version ||= 1
  end

  def increment_workbench_local_id
    # workbench_object_identifier = self.referential.workbench.worbench_object_identifiers.find_or_create_by_object_class(self.class)
    # result = WorbenchObjectIdentifier.increment_counter(:last_local_id, 1)
    # counter = 3
    # # Ecrire le code pour répéter l'opération 3 fois au cas ou l'enregistrement échouerait.
    # while result == false && counter <= 3
    #  .....
    # end
  end
end
