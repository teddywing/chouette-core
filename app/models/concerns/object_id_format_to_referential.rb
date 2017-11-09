module ObjectIdFormatToReferential
  def objectid_format
    "#{self.referential.objectid_format}_attributes_support".camelcase.constantize
  end
end
