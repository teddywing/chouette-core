class ComplianceCheckSetDecorator < AF83::Decorator
  decorates ComplianceCheckSet

  with_instance_decorator do |instance_decorator|
    instance_decorator.show_action_link
  end

  define_instance_method :lines_status do
    object.compliance_check_resources.where(status: :OK, resource_type: :line).count
  end

  define_instance_method :lines_in_compliance_check_set do
    object.compliance_check_resources.where(resource_type: :line).count
  end

end
