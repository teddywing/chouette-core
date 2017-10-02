FactoryGirl.define do
  factory :compliance_control_block do
    sequence(:name) { |n| "Compliance control block #{n}" }
    transport_mode "air"
    association :compliance_control_set
  end
end
