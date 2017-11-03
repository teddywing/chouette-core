FactoryGirl.define do
  factory :referential do
    sequence(:name) { |n| "Test #{n}" }
    sequence(:slug) { |n| "test_#{n}" }
    sequence(:prefix) { |n| "test_#{n}" }
    association :line_referential
    association :stop_area_referential
    association :organisation
    time_zone "Europe/Paris"
    ready { true }

    factory :workbench_referential do
      association :workbench
      before :create do | ref |
        ref.workbench.organisation = ref.organisation
      end
    end
  end
end
