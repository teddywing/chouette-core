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

    referential.switch do
      line_referential.lines.each do |line|
        3.times do
          stop_areas = stop_area_referential.stop_areas.order("random()").limit(5)
          FactoryGirl.create :route, line: line, stop_areas: stop_areas, stop_points_count: 0
        end
      end

      referential.routes.each do |route|
        3.times do
          FactoryGirl.create :journey_pattern, route: route, stop_points: route.stop_points.sample(3)
        end
      end

      referential.journey_patterns.each do |journey_pattern|
        3.times do
          v = FactoryGirl.create :vehicle_journey, journey_pattern: journey_pattern, company: company
          puts v.checksum_source
        end
      end
    end

    merge = Merge.create!(workbench: referential.workbench, referentials: [referential, referential])
    merge.merge!
  end

end
