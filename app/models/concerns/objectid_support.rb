module ObjectidSupport
  extend ActiveSupport::Concern

  included do
    before_validation :before_validation_objectid
    after_commit :after_commit_objectid
    validates_presence_of :objectid_format, :objectid
    validates_uniqueness_of :objectid 

    def before_validation_objectid
      self.referential.objectid_formater.before_validation self
    end

    def after_commit_objectid
      self.referential.objectid_formater.after_commit self
    end

    def objectid
      self.referential.objectid_formater.parse_objectid read_attribute(:objectid) if objectid_format && read_attribute(:objectid)
    end

    def objectid_format
      self.referential.objectid_format
    end
  end
end