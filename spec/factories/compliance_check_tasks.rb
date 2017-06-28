FactoryGirl.define do
  factory :compliance_check_task do
    user_id 1
    user_name "Dummy"
    status "pending"
    referential { Referential.find_by_slug("first") }
  end
end
