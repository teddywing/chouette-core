FactoryGirl.define do
  factory :user do
    association :organisation
    sequence(:name) { |n| "chouette#{n}" }
    sequence(:username) { |n| "chouette#{n}" }
    sequence(:email) { |n| "chouette#{n}@dryade.priv" }
    password "secret"
    password_confirmation "secret"
  end
end
