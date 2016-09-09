FactoryGirl.define do
  factory :stop_area_referential_sync do
    stop_area_referential nil

    factory :stop_area_referential_sync_with_record do
      transient do
        stop_area_sync_operations_count rand(1..30)
      end

      after(:create) do |stop_area_referential_sync, evaluator|
        create_list(:stop_area_sync_operation, evaluator.stop_area_sync_operations_count, stop_area_referential_sync: stop_area_referential_sync)
      end
    end
  end
end
