FactoryGirl.define do
  factory :line_referential_sync do
    line_referential nil

    factory :line_referential_sync_with_record do
      transient do
        line_sync_operations_count rand(1..30)
      end
      
      after(:create) do |line_referential_sync, evaluator|
        create_list(:line_sync_operation, evaluator.line_sync_operations_count, line_referential_sync: line_referential_sync)
      end
      
    end
  end
end
