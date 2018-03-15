require "rails_helper"

RSpec.describe Merge do

  it "should work" do
    stop_area_referential = FactoryGirl.create :stop_area_referential
    10.times { FactoryGirl.create :stop_area, stop_area_referential: stop_area_referential }

    line_referential = FactoryGirl.create :line_referential
    company = FactoryGirl.create :company, line_referential: line_referential
    10.times { FactoryGirl.create :line, line_referential: line_referential, company: company, network: nil }

    workbench = FactoryGirl.create :workbench, line_referential: line_referential, stop_area_referential: stop_area_referential

    referential_metadata = FactoryGirl.create(:referential_metadata, lines: line_referential.lines.limit(3))

    referential = FactoryGirl.create :referential,
                                      workbench: workbench,
                                      organisation: workbench.organisation,
                                      metadatas: [referential_metadata]

    factor = 1
    stop_points_positions = {}

    referential.switch do
      line_referential.lines.each do |line|
        factor.times do
          stop_areas = stop_area_referential.stop_areas.order("random()").limit(5)
          FactoryGirl.create :route, line: line, stop_areas: stop_areas, stop_points_count: 0
        end
      end

      referential.routes.each do |route|
        route.stop_points.each do |sp|
          sp.set_list_position 0
        end
        route.reload.update_checksum!
        factor.times do
          FactoryGirl.create :journey_pattern, route: route, stop_points: route.stop_points.sample(3)
        end
      end

      referential.journey_patterns.each do |journey_pattern|
        stop_points_positions[journey_pattern.name] = Hash[*journey_pattern.stop_points.map{|sp| [sp.stop_area_id, sp.position]}.flatten]
        factor.times do
          FactoryGirl.create :vehicle_journey, journey_pattern: journey_pattern, company: company
        end
      end

      shared_time_table = FactoryGirl.create :time_table

      referential.vehicle_journeys.each do |vehicle_journey|
        vehicle_journey.time_tables << shared_time_table

        specific_time_table = FactoryGirl.create :time_table
        vehicle_journey.time_tables << specific_time_table
      end
    end

    merge = Merge.create!(workbench: referential.workbench, referentials: [referential, referential])
    merge.merge!

    output = merge.output.current
    output.switch

    # Let's check stop_point positions are respected
    # This should be enforced by the checksum preservation though
    output.journey_patterns.each do |journey_pattern|
      journey_pattern.stop_points.each do |sp|
        expect(sp.position).to eq stop_points_positions[journey_pattern.name][sp.stop_area_id]
      end
    end

  end

end
