FactoryGirl.define do
  factory :compliance_control_block do
    sequence(:name) { |n| "Compliance control block #{n}" }
    compliance_control_set
  end
end
