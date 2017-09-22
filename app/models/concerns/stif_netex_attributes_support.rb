module StifNetexAttributesSupport
  extend ActiveSupport::Concern

  included do
    validates_numericality_of :object_version
    validates :objectid, uniqueness: true, presence: true
    validate :objectid_format_compliance

    after_save :build_objectid
    before_validation :default_values, on: :create
  end

  module ClassMethods
    def object_id_key
      model_name
    end

    def model_name
      ActiveModel::Name.new self, Chouette, self.name.demodulize
    end
  end

  def objectid_format_compliance
    errors.add :objectid, I18n.t("activerecord.errors.models.trident.invalid_object_id") if !objectid.valid?
  end

  def local_id
    "IBOO-#{self.referential.id}-#{self.id}"
  end

  def build_objectid
    if objectid.include? ':__pending_id__'
      self.objectid = Chouette::StifNetexObjectid.create(self.provider_id, self.model_name, self.local_id, self.boiv_id)
      self.save
    end
  end

  def default_values
    self.object_version ||= 1

    if self.objectid.to_s.empty?
      local_id = "__pending_id__#{rand(50)+ rand(50)}"
      self.objectid = Chouette::StifNetexObjectid.create(self.provider_id, self.model_name, local_id, self.boiv_id)
    end
  end

  def objectid
    Chouette::StifNetexObjectid.new read_attribute(:objectid)
  end

  def provider_id
    self.referential.workbench.organisation.name.parameterize.underscore
  end

  def boiv_id
    'LOC'
  end
end
