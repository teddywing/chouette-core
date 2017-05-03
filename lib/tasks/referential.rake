# coding: utf-8
# execution example: rake 'referential:create[3, 1896, '01-01-2017', '01-04-2017']'

namespace :referential do
  desc 'Create a referential and accompanying data'
  task :create, [:workbench_id, :start_date, :end_date] => [:environment] do |t, args|
    args.with_defaults(workbench_id: 1, start_date: Date.today.strftime, end_date: (Date.today + 30).strftime)

    Referential.transaction do
      workbench = Workbench.find_by!(id: args[:workbench_id])
      line = workbench.line_referential.lines.order("random()").first
      name = "Referential #{Faker::Name.unique.name}"

      referential = workbench.referentials.create!(name: name, slug: name.downcase.parameterize.underscore, organisation: workbench.organisation,
                                                   prefix: Faker::Lorem.unique.characters(10))
      ReferentialMetadata.create!(referential: referential, line_ids: [line.id], periodes: [Date.parse(args[:start_date])..Date.parse(args[:end_date])])
      referential.switch

      print "✓ Created Referential ".green, name, "(#{referential.id})".blue, "\n"
      puts "  For inspection of data in the console, do a: `Referential.last.switch'".blueish

      stop_areas = workbench.stop_area_referential.stop_areas.last(10)

      4.times do |i|
        route_attrs = { line: line, name: "Route #{Faker::Name.unique.name}" }
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
        print "  ✓ Created Route ".green, route.name, "(#{route.id}), ".blue, "Line (#{line.id}) has #{line.routes.count} routes\n"

        journey_pattern = Chouette::JourneyPattern.create!(route: route, name: "Journey Pattern #{Faker::Name.unique.name}")
        journey_pattern.stop_points = stop_areas.inject([]) { |stop_points, stop_area| stop_points += stop_area.stop_points }

        time_tables = []
        2.times do |j|
          name = "Test #{Faker::Name.unique.name}"
          time_table = Chouette::TimeTable.create!(comment: name, start_date: Date.parse(args[:start_date]) + j.days,
                                                   end_date: Date.parse(args[:end_date]) - j.days)
          time_tables << time_table
        end

        25.times do |j|
          vehicle_journey = Chouette::VehicleJourney.create!(journey_pattern: journey_pattern, route: route, number: Faker::Number.unique.number(4), time_tables: time_tables)
          time = Time.current.at_noon + j.minutes
          journey_pattern.stop_points.each_with_index do |stop_point, k|
            vehicle_journey.vehicle_journey_at_stops.create!(stop_point: stop_point, arrival_time: time + k.minutes, departure_time: time + k.minutes + 30.seconds)
          end
        end

      end

      referential.update(ready: true)
    end
  end
end
