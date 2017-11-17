module ObjectidSupport
  extend ActiveSupport::Concern

  included do
    before_validation :before_validation_objectid
    after_create :after_create_objectid
    validates_presence_of :objectid_format, :objectid
    validates_uniqueness_of :objectid, skip_validation: Proc.new {|model| model.objectid == nil}

    def before_validation_objectid
      self.referential.objectid_formater.before_validation self
    end

    def after_create_objectid
      self.referential.objectid_formater.after_create self
    end

    def get_objectid
      self.referential.objectid_formater.get_objectid read_attribute(:objectid) if objectid_format && read_attribute(:objectid)
    end

    def objectid
      get_objectid.try(:to_s)
    end

    def objectid_format
      self.referential.objectid_format
    end
  end
end