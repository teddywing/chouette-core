FactoryGirl.define do
  factory :import_message do
    association :import
    association :resource, factory: :import_resource
    criticity :info
  end
end
