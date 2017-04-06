FactoryGirl.define do
  factory :routing_constraint_zone, class: Chouette::RoutingConstraintZone do
    sequence(:name) { |n| "Routing constraint zone #{n}" }
    stop_area_ids { [create(:stop_area).id, create(:stop_area).id] }
    association :route, factory: :route
  end
end
