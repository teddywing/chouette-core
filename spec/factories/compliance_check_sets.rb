FactoryGirl.define do
  factory :compliance_check_set do
    status :new
    referential
    compliance_control_set
    workbench
  end
end
