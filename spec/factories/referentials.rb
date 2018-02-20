FactoryGirl.define do
  factory :referential do
    sequence(:name) { |n| "Test #{n}" }
    sequence(:slug) { |n| "test-#{n}_#{Time.now.to_i}" }
    sequence(:prefix) { |n| "test_#{n}" }
    association :line_referential
    association :stop_area_referential
    association :organisation
    time_zone "Europe/Paris"
    ready { true }
    objectid_format "stif_netex"

    factory :workbench_referential do
      association :workbench
      before :create do | ref |
        ref.workbench.organisation = ref.organisation
      end
    end
  end
end
