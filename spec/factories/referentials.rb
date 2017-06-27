FactoryGirl.define do
  factory :referential do
    sequence(:name) { |n| "Test #{n}" }
    sequence(:slug) { |n| "test_#{n}" }
    sequence(:prefix) { |n| "test_#{n}" }
    association :organisation
    association :workbench
    association :line_referential
    association :stop_area_referential
    time_zone "Europe/Paris"
  end
end
