FactoryGirl.define do
  factory :compliance_check_resource do
    status :new
    sequence(:name) { |n| "Compliance check resource #{n}" }
  end
end
