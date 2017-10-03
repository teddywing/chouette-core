FactoryGirl.define do
  factory :generic_attribute_control_min_max, class: 'GenericAttributeControl::MinMax' do
    sequence(:name) { |n| "MinMax control #{n}" }
    association :compliance_control_set
  end

  factory :generic_attribute_control_pattern, class: 'GenericAttributeControl::Pattern' do
    sequence(:name) { |n| "Pattern control #{n}" }
    association :compliance_control_set
  end

  factory :generic_attribute_control_uniqueness, class: 'GenericAttributeControl::Uniqueness' do
    sequence(:name) { |n| "Uniqueness control #{n}" }
    association :compliance_control_set
  end
end
