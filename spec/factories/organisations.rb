FactoryGirl.define do
  factory :organisation do
    sequence(:name) { |n| "Organisation #{n}" }
    sequence(:code) { |n| "000#{n}" }
  end
end
