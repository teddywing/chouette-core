FactoryGirl.define do
  factory :compliance_control do
    sequence(:name) { |n| "Compliance control #{n}" }
    type "Type"
    criticity :info
    code "code"
    comment "Text"
    association :compliance_control_set
    association :compliance_control_block
  end
end
