FactoryGirl.define do
  factory :compliance_check_message do
    association :compliance_check
    association :compliance_check_resource
    message_key "message_key"
  end
end
