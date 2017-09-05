FactoryGirl.define do
  factory :compliance_control do
    sequence(:name) { |n| "Compliance control #{n}" }
    type "Type"
    criticity :info
    code "code"
    comment "Text"
    compliance_control_set
    compliance_control_block
  end
end
