module DefaultNetexAttributesSupport
  extend ActiveSupport::Concern

  included do
    before_validation :prepare_auto_columns

    validates_presence_of :objectid
    validates_uniqueness_of :objectid
    validates_numericality_of :object_version
    validate :objectid_format_compliance

    before_validation :default_values, :on => :create
  end

  module ClassMethods
    def object_id_key
      model_name
    end

    def model_name
      ActiveModel::Name.new self, Chouette, self.name.demodulize
    end
  end

  def objectid
    Chouette::NetexObjectId.new read_attribute(:objectid)
  end

  def prepare_auto_columns
    if object_version.nil?
      self.object_version = 1
    else
      self.object_version += 1
    end
    self.creator_id = 'chouette'
  end

  def fix_uniq_objectid
    base_objectid = objectid.rpartition(":").first
    self.objectid = "#{base_objectid}:#{id}"
    if !valid?
      base_objectid="#{objectid}_"
      cnt=1
      while !valid?
        self.objectid = "#{base_objectid}#{cnt}"
        cnt += 1
      end
    end

  end

  def objectid_format_compliance
    if !objectid.valid?
      errors.add :objectid, I18n.t("activerecord.errors.models.trident.invalid_object_id", type: self.class.object_id_key)
    end
  end

  def uniq_objectid
    # OPTIMIZEME
    i = 0
    baseobjectid = objectid
    while self.class.exists?(:objectid => objectid)
      i += 1
      self.objectid = baseobjectid+"_"+i.to_s
    end
  end

  def default_values
    self.object_version ||= 1
  end

end
