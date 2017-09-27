FactoryGirl.define do
  factory :compliance_control do
    sequence(:name) { |n| "Compliance control #{n}" }
    type "GenericAttributeControl::MinMax"
    criticity :warning
    code "code"
    origin_code "code"
    comment "Text"
    association :compliance_control_set
  end
end
