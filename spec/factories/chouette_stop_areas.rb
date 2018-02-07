FactoryGirl.define do
  factory :stop_area, :class => Chouette::StopArea do
    sequence(:objectid) { |n| "FR:#{n}:ZDE:#{n}:STIF" }
    sequence(:name) { |n| "stop_area_#{n}" }
    sequence(:registration_number) { |n| "test-#{n}" }
    area_type { Chouette::AreaType.commercial.sample }
    latitude {10.0 * rand}
    longitude {10.0 * rand}
    kind "commercial"

    association :stop_area_referential

    trait :deactivated do
      deleted_at { 1.hour.ago }
    end
  end
end
