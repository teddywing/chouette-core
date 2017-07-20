module DefaultAttributesSupport
  extend ActiveSupport::Concern

  included do
    before_validation :prepare_auto_columns
    after_validation :reset_auto_columns

    after_save :build_objectid

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
    Chouette::ObjectId.new read_attribute(:objectid)
  end

  def prepare_auto_columns
    if objectid.nil? || objectid.blank?
      if id.nil?
        self.objectid = "#{prefix}:#{self.class.object_id_key}:__pending_id__#{rand(1000)}"
      else
        self.objectid = "#{prefix}:#{self.class.object_id_key}:#{id}"
        fix_uniq_objectid
      end
    elsif not objectid.include? ':'
      # if one token : technical token : completed by prefix and key
      self.objectid = "#{prefix}:#{self.class.object_id_key}:#{objectid}"
    end

    if object_version.nil?
      self.object_version = 1
    else
      self.object_version += 1
    end
    self.creator_id = 'chouette'
  end

  def reset_auto_columns
    clean_object_id unless errors.nil? || errors.empty?
  end

  def clean_object_id
    if objectid.include?("__pending_id__")
      self.objectid=nil
    end
  end

  def fix_uniq_objectid
    base_objectid = objectid.rpartition(":").first
    self.objectid = "#{base_objectid}:#{id}"
    if !valid?(:objectid)
      base_objectid="#{objectid}_"
      cnt=1
      while !valid?(:objectid)
        self.objectid = "#{base_objectid}#{cnt}"
        cnt += 1
      end
    end

  end

  def build_objectid
    if objectid.include? ':__pending_id__'
      fix_uniq_objectid
      self.object_version = object_version - 1
      self.save(validate: false)
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
