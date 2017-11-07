module ComplianceControlsHelper
  def subclass_selection_list
    ComplianceControl.subclass_patterns.map(&method(:make_subclass_selection_item))
  end


  def make_subclass_selection_item(key_pattern)
    key, pattern = key_pattern
    [t("compliance_controls.filters.subclasses.#{key}"), "-#{pattern}-"]
  end
end 
