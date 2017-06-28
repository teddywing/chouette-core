FactoryGirl.define do
  factory :rule_parameter_set do
    sequence(:name) { |n| "Test #{n}" }
    association :organisation
    after(:create) do |rsp|
      rsp.parameters = RuleParameterSet.default_for_all_modes( rsp.organisation).parameters
    end
  end
end
