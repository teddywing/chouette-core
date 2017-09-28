FactoryGirl.define do
  factory :compliance_control_block do
    sequence(:name) { |n| "Compliance control block #{n}" }
    association :compliance_control_set
  end
end
