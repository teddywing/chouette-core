FactoryGirl.define do
  factory :compliance_check_set do
    status :new
    association :referential
    association :compliance_control_set
    association :workbench
  end
end
