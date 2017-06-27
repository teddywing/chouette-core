FactoryGirl.define do
  factory :export do
    referential { Referential.find_by_slug("first") }
  end
end
