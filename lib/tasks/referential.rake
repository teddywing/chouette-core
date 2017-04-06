# execution example: rake 'referential:create[3, 1896, '01-01-2017', '01-04-2017']'

namespace :referential do
  desc 'Create a referential and accompanying data'
  task :create, [:workbench_id, :line_id, :start_date, :end_date] => [:environment] do |t, args|
    workbench = Workbench.find_by!(id: args[:workbench_id])
    line = workbench.line_referential.lines.find_by!(id: args[:line_id])
    name = "Referential #{Faker::Name.unique.name}"
    referential = workbench.referentials.create!(name: name, slug: name.downcase.parameterize.underscore, organisation: workbench.organisation,
     prefix: Faker::Lorem.unique.characters(10))
    ReferentialMetadata.create!(referential: referential, line_ids: [args[:line_id]], periodes: [Date.parse(args[:start_date])..Date.parse(args[:end_date])])
    referential.switch

    routes = []
    stop_areas = workbench.stop_area_referential.stop_areas.last(10)

    4.times do |i|
      route_attrs = { line_id: args[:line_id].to_i, name: "Route #{Faker::Name.unique.name}" }
      if i.even?
        route_attrs[:wayback] = :straight_forward
        route = Chouette::Route.create!(route_attrs)
        route.stop_areas = stop_areas
      else
        route_attrs[:wayback] = :backward
        route_attrs[:opposite_route] = Chouette::Route.last if i == 3
        route = Chouette::Route.create!(route_attrs)
        route.stop_areas = stop_areas.reverse
      end
      route.save!

      journey_pattern = Chouette::JourneyPattern.create!(route: route, name: "Journey pattern #{Faker::Name.unique.name}")
      journey_pattern.stop_points = stop_areas.inject([]) { |stop_points, stop_area| stop_points += stop_area.stop_points }

      25.times do |j|
        vehicle_journey = Chouette::VehicleJourney.create!(journey_pattern: journey_pattern, route: route, number: Faker::Number.unique.number(4))
        time = Time.current.at_noon + j.minutes
        journey_pattern.stop_points.each_with_index do |stop_point, k|
          vjas = Chouette::VehicleJourneyAtStop.create!(stop_point: stop_point, arrival_time: time + k.minutes, departure_time: time + k.minutes + 30.seconds)
        end
      end

      2.times do |j|
        name = "Calendar #{Faker::Name.unique.name}"
        calendar = Calendar.create!(name: name, short_name: name.parameterize, organisation: workbench.organisation,
          date_ranges: [(Date.parse(args[:start_date]) + j.days)..(Date.parse(args[:end_date]) - j.days)])
        Chouette::TimeTable.create!(comment: Faker::Lorem.sentence(3), calendar: calendar, start_date: Date.parse(args[:start_date]) + j.days,
          end_date: Date.parse(args[:end_date]) - j.days)
      end
    end

  end
end




