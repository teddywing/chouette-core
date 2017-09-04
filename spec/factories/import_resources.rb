FactoryGirl.define do
  factory :import_resource do
    association :import
    status :WARNING
    sequence(:name) { |n| "Import resource #{n}" }
    resource_type 'type'
    reference 'reference'
  end
end
