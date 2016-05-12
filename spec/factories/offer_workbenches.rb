FactoryGirl.define do
  factory :offer_workbench do
    sequence(:name) { |n| "Offer workbench #{n}" }
    
    association :organisation, :factory => :organisation
  end
end
