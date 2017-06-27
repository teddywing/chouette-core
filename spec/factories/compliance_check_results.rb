FactoryGirl.define do
  factory :compliance_check_result do
    association :compliance_check_task
    rule_code "2-NEPTUNE-StopArea-6"
    severity "warning"
    status "nok"
  end
end
