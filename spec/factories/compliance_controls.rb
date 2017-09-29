FactoryGirl.define do
  factory :compliance_control do
    sequence(:name) { |n| "Compliance control #{n}" }
    type "GenericAttributeControl::MinMax"
    criticity :warning
    code "code"
    origin_code "code"
    comment "Text"
    association :compliance_control_set
    association :compliance_control_block
  end

  factory :min_max, class: 'GenericAttributeControl::MinMax' do
    sequence(:name) { |n| "MinMax control #{n}" }
    association :compliance_control_set
    association :compliance_control_block
  end

  factory :pattern, class: 'GenericAttributeControl::Pattern' do
    sequence(:name) { |n| "Pattern control #{n}" }
    association :compliance_control_set
    association :compliance_control_block
  end

  factory :uniqueness, class: 'GenericAttributeControl::Uniqueness' do
    sequence(:name) { |n| "Uniqueness control #{n}" }
    association :compliance_control_set
    association :compliance_control_block
  end
end
