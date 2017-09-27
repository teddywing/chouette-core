FactoryGirl.define do
  factory :compliance_control do
    sequence(:name) { |n| "Compliance control #{n}" }
    type "GenericAttributeMinMax"
    criticity :warning
    code "code"
    comment "Text"
    association :compliance_control_set
  end
end
