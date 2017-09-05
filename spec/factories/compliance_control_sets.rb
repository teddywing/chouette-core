FactoryGirl.define do
  factory :compliance_control_set do
    sequence(:name) { |n| "Compliance control set #{n}" }
    organisation
  end
end
