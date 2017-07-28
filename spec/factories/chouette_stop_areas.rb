FactoryGirl.define do
  factory :stop_area, :class => Chouette::StopArea do
    sequence(:objectid) { |n| "FR:#{n}:ZDE:#{n}:STIF" }
    sequence(:name) { |n| "stop_area_#{n}" }
    sequence(:registration_number) { |n| "test-#{n}" }
    area_type { Chouette::StopArea.area_type.values.sample }
    latitude {10.0 * rand}
    longitude {10.0 * rand}

    association :stop_area_referential
  end
end
