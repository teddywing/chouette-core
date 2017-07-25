FactoryGirl.define do

  factory :network, :class => Chouette::Network do
    sequence(:name) { |n| "Network #{n}" }
    sequence(:objectid) { |n| "chouette:GroupOfLine:#{n}:loc" }
    sequence(:registration_number) { |n| "test-#{n}" }

    association :line_referential
  end
end
