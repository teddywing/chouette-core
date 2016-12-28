FactoryGirl.define do
  factory :import_resource do
    association :import
    status :new
  end
end
