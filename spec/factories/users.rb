all_permissions = %w[
      footnotes
      journey_patterns
      referentials
      routes
      routing_constraint_zones
      time_tables
      vehicle_journeys
    ].product( %w{create destroy update} ).map{ |model_action| model_action.join('.') }

FactoryGirl.define do
  factory :user do
    association :organisation
    sequence(:name) { |n| "chouette#{n}" }
    sequence(:username) { |n| "chouette#{n}" }
    sequence(:email) { |n| "chouette#{n}@dryade.priv" }
    password "secret"
    password_confirmation "secret"
    factory :allmighty_user do
      permissions all_permissions
    end
  end
end
