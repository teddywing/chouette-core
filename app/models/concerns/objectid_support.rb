module ObjectidSupport
  extend ActiveSupport::Concern

  included do
    before_validation :before_validation_objectid
    after_commit :after_commit_objectid, on: :create, if: Proc.new {|model| model.read_attribute(:objectid).try(:include?, '__pending_id__')}
    validates_presence_of :objectid_format, :objectid
    validates_uniqueness_of :objectid, skip_validation: Proc.new {|model| model.read_attribute(:objectid).nil?}

    def before_validation_objectid
      self.referential.objectid_formater.before_validation self
    end

    def after_commit_objectid
      self.referential.objectid_formater.after_commit self
    end

    def get_objectid
      self.referential.objectid_formater.get_objectid read_attribute(:objectid) if objectid_format && read_attribute(:objectid)
    end

    def get_objectid
      self.referential.objectid_formater.get_objectid read_attribute(:objectid) if objectid_format && read_attribute(:objectid)
    end

    def objectid
      get_objectid.try(:to_s)
    end

    def objectid_class
      get_objectid.try(:class)
    end

    def objectid_format
      self.referential.objectid_format
    end
  end
end
