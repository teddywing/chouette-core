FactoryGirl.define do
  factory :abstract_referential, class: Referential do
    sequence(:name) { |n| "Test #{n}" }
    sequence(:slug) { |n| "test_#{n}" }
    sequence(:prefix) { |n| "test_#{n}" }

    time_zone "Europe/Paris"
    ready { true }

    factory :referential do
      association :organisation
      association :workbench
      association :line_referential
      association :stop_area_referential
    end

    factory :fast_referential do
      association :organisation, strategy: :build
      association :workbench, strategy: :build
      association :line_referential, strategy: :build
      association :stop_area_referential, strategy: :build
    end
  end
end
