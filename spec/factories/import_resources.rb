FactoryGirl.define do
  factory :import_resource do
    association :import
    status :new
    sequence(:name) { |n| "Import resource #{n}" }
    type 'type'
    reference 'reference'
  end
end
