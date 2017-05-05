RSpec.describe Chouette::Route, :type => :model do

  subject { create(:route) }


  context "delete a route" do
    let( :vehicle_journey ){ create :vehicle_journey }

    it "deletes the associated journey_patterns" do
      expected_delta = subject.journey_patterns.count
      expect( expected_delta ).to be_positive
      expect{ subject.destroy }.to change{Chouette::JourneyPattern.count}.by -expected_delta
    end

    it "deletes the associated stop_points" do
      expected_delta = subject.stop_points.count
      expect( expected_delta ).to be_positive
      expect{ subject.destroy }.to change{Chouette::StopPoint.count}.by -expected_delta
    end

    it "does not delete the associated stop_areas" do
      count = subject.stop_points.count
      expect( count ).to be_positive
      expect{ subject.destroy }.not_to change{Chouette::StopArea.count}
    end

    it "deletes the associated vehicle_journeys" do
      expect{ vehicle_journey.route.destroy}.to change{Chouette::VehicleJourney.count}.by -1
    end

    it "does not delete the corresponding time_tables" do
      tt = create :time_table
      tt.vehicle_journeys << vehicle_journey
      tables = vehicle_journey.route.time_tables
      expect( tables ).not_to be_empty
      expect{ vehicle_journey.route.destroy }.not_to change{Chouette::TimeTable.count}
    end

    it "does not delete the associated line" do
      expect( subject.line ).not_to be_nil
      expect{ subject.destroy }.not_to change{Chouette::Line.count}
    end
  end
end
