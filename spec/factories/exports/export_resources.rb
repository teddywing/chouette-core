FactoryGirl.define do
  factory :export_resource, class: Export::Resource do
    association :export
    status :WARNING
    sequence(:name) { |n| "Export resource #{n}" }
    resource_type 'type'
    reference 'reference'
  end
end
