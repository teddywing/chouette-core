FactoryGirl.define do

  factory :route_common, :class => Chouette::Route do
    sequence(:name) { |n| "Route #{n}" }
    sequence(:published_name) { |n| "Long route #{n}" }
    sequence(:number) { |n| "#{n}" }
    sequence(:wayback) { |n| Chouette::Route.wayback.values[n % 2] }
    sequence(:direction) { |n| Chouette::Route.direction.values[n % 12] }
    sequence(:objectid) { |n| "test:Route:#{n}" }

    association :line, :factory => :line

    factory :route do

      transient do
        stop_points_count 5
      end

      after(:create) do |route, evaluator|
        create_list(:stop_point, evaluator.stop_points_count, route: route)
        route.reload
      end

      factory :route_with_journey_patterns do
        transient do
          journey_patterns_count 2
        end

        after(:create) do |route, evaluator|
          create_list(:journey_pattern, evaluator.journey_patterns_count, route: route)
        end

      end
    end

  end

end
