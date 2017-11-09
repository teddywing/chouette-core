module ObjectIdFormatToLineReferential
  def objectid_format
    "#{self.line_referential.objectid_format}_attributes_support".camelcase.constantize
  end
end
