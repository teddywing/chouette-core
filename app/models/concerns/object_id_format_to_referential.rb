module ObjectIdFormatToReferential
  extend ActiveSupport::Concern

  included do
    validates_presence_of :objectid_format
  end

  def objectid_format
    "#{self.referential.objectid_format}_attributes_support".camelcase.constantize if self.referential.objectid_format
  end
end
