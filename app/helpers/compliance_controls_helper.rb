module ComplianceControlsHelper
  def subclass_selection_list
    ComplianceControl.subclass_patterns.map(&method(:make_subclass_selection_item))
  end


  def make_subclass_selection_item(key_pattern)
    key, pattern = key_pattern
    [t("compliance_controls.filters.subclasses.#{key}"), "-#{pattern}-"]
  end

  def compliance_control_metadatas(compliance_control)
    attributes = resource.class.dynamic_attributes
    attributes.push(*resource.control_attributes.keys) if resource&.control_attributes&.keys

    {}.tap do |hash|
      attributes.each do |attribute|
        hash[ComplianceControl.human_attribute_name(attribute)] = resource.send(attribute)
      end
    end
  end
end
