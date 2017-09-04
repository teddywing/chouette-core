FactoryGirl.define do
  factory :import_resource do
    association :import
    status :new
    sequence(:name) { |n| "Import resource #{n}" }
    resource_type 'type'
    reference 'reference'
  end
end
