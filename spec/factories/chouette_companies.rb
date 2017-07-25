FactoryGirl.define do

  factory :company, :class => Chouette::Company do
    sequence(:name) { |n| "Company #{n}" }
    sequence(:objectid) { |n| "chouette:Company:#{n}:loc" }
    sequence(:registration_number) { |n| "test-#{n}" }

    association :line_referential, :factory => :line_referential
  end

end
