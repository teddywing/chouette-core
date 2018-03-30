require "rails_helper"

RSpec.describe Import::Gtfs do

  let(:referential) do
    create :referential do |referential|
      referential.line_referential.objectid_format = "netex"
      referential.stop_area_referential.objectid_format = "netex"
    end
  end

  def create_import(file)
    Import::Gtfs.new referential: referential, local_file: fixtures_path(file)
  end

  describe "#import_agencies" do
    let(:import) { create_import "google-sample-feed.zip" }
    it "should create a company for each agency" do
      import.import_agencies

      expect(referential.line_referential.companies.pluck(:registration_number, :name)).to eq([["DTA","Demo Transit Authority"]])
    end
  end

  describe "#import_stops" do
    let(:import) { create_import "google-sample-feed.zip" }
    it "should create a company for each agency" do
      import.import_stops

      defined_attributes = [
        :registration_number, :name, :parent_id, :latitude, :longitude
      ]
      expected_attributes = [
        ["AMV", "Amargosa Valley (Demo)", nil, 36.641496, -116.40094],
        ["EMSI", "E Main St / S Irving St (Demo)", nil, 36.905697, -116.76218],
        ["DADAN", "Doing Ave / D Ave N (Demo)", nil, 36.909489, -116.768242],
        ["NANAA", "North Ave / N A Ave (Demo)", nil, 36.914944, -116.761472],
        ["NADAV", "North Ave / D Ave N (Demo)", nil, 36.914893, -116.76821],
        ["STAGECOACH", "Stagecoach Hotel & Casino (Demo)", nil, 36.915682, -116.751677],
        ["BULLFROG", "Bullfrog (Demo)", nil, 36.88108, -116.81797],
        ["BEATTY_AIRPORT", "Nye County Airport (Demo)", nil, 36.868446, -116.784582],
        ["FUR_CREEK_RES", "Furnace Creek Resort (Demo)", nil, 36.425288, -117.133162]
      ]

      expect(referential.stop_area_referential.stop_areas.pluck(*defined_attributes)).to eq(expected_attributes)
    end
  end

  describe "#import_routes" do
    let(:import) { create_import "google-sample-feed.zip" }
    it "should create a line for each route" do
      import.import_routes

      defined_attributes = [
        :registration_number, :name, :number, :published_name,
        "companies.registration_number",
        :comment, :url
      ]
      expected_attributes = [
        ["AAMV", "Airport - Amargosa Valley", "50", "Airport - Amargosa Valley", nil, nil, nil],
        ["CITY", "City", "40", "City", nil, nil, nil],
        ["STBA", "Stagecoach - Airport Shuttle", "30", "Stagecoach - Airport Shuttle", nil, nil, nil],
        ["BFC", "Bullfrog - Furnace Creek Resort", "20", "Bullfrog - Furnace Creek Resort", nil, nil, nil],
        ["AB", "Airport - Bullfrog", "10", "Airport - Bullfrog", nil, nil, nil]
      ]

      expect(referential.line_referential.lines.includes(:company).pluck(*defined_attributes)).to eq(expected_attributes)
    end
  end

  describe "#import_trips" do
    let(:import) { create_import "google-sample-feed.zip" }
    it "should create a Route for each trip" do
      referential.switch

      import.import_routes
      import.import_trips


      defined_attributes = [
        "lines.registration_number", :wayback, :name, :published_name
      ]
      expected_attributes = [
        ["AB", "outbound", "to Bullfrog", "to Bullfrog"],
        ["AB", "inbound", "to Airport", "to Airport"],
        ["STBA", "inbound", "Shuttle", "Shuttle"],
        ["CITY", "outbound", "Outbound", "Outbound"],
        ["CITY", "inbound", "Inbound", "Inbound"],
        ["BFC", "outbound", "to Furnace Creek Resort", "to Furnace Creek Resort"],
        ["BFC", "inbound", "to Bullfrog", "to Bullfrog"],
        ["AAMV", "outbound", "to Amargosa Valley", "to Amargosa Valley"],
        ["AAMV", "inbound", "to Airport", "to Airport"],
        ["AAMV", "outbound", "to Amargosa Valley", "to Amargosa Valley"],
        ["AAMV", "inbound", "to Airport", "to Airport"]
      ]

      expect(referential.routes.includes(:line).pluck(*defined_attributes)).to eq(expected_attributes)
    end

    it "should create a JourneyPattern for each trip" do
      referential.switch

      import.import_routes
      import.import_trips

      defined_attributes = [
        :name
      ]
      expected_attributes = [
        "to Bullfrog", "to Airport", "Shuttle", "Outbound", "Inbound", "to Furnace Creek Resort", "to Bullfrog", "to Amargosa Valley", "to Airport", "to Amargosa Valley", "to Airport"
      ]

      expect(referential.journey_patterns.pluck(*defined_attributes)).to eq(expected_attributes)
    end

    it "should create a VehicleJourney for each trip" do
      referential.switch

      import.import_routes
      import.import_trips

      defined_attributes = [
        :published_journey_name
      ]
      expected_attributes = [
        "to Bullfrog", "to Airport", "Shuttle", "CITY1", "CITY2", "to Furnace Creek Resort", "to Bullfrog", "to Amargosa Valley", "to Airport", "to Amargosa Valley", "to Airport"
      ]

      expect(referential.vehicle_journeys.pluck(*defined_attributes)).to eq(expected_attributes)
    end
  end

  describe "#import_stop_times" do
    let(:import) { create_import "google-sample-feed.zip" }

    it "should create a VehicleJourneyAtStop for each stop_time" do
      referential.switch

      import.import_stops
      import.import_routes
      import.import_trips
      import.import_stop_times

      def t(value)
        Time.parse(value)
      end

      defined_attributes = [
        "stop_areas.registration_number", :position, :departure_time, :arrival_time,
      ]
      expected_attributes = [
        ["STAGECOACH", 0, t("2000-01-01 06:00:00 UTC"), t("2000-01-01 06:00:00 UTC")],
        ["BEATTY_AIRPORT", 1, t("2000-01-01 06:20:00 UTC"), t("2000-01-01 06:20:00 UTC")],
        ["STAGECOACH", 0, t("2000-01-01 06:00:00 UTC"), t("2000-01-01 06:00:00 UTC")],
        ["NANAA", 1, t("2000-01-01 06:07:00 UTC"), t("2000-01-01 06:05:00 UTC")],
        ["NADAV", 2, t("2000-01-01 06:14:00 UTC"), t("2000-01-01 06:12:00 UTC")],
        ["DADAN", 3, t("2000-01-01 06:21:00 UTC"), t("2000-01-01 06:19:00 UTC")],
        ["EMSI", 4, t("2000-01-01 06:28:00 UTC"), t("2000-01-01 06:26:00 UTC")],
        ["EMSI", 0, t("2000-01-01 06:30:00 UTC"), t("2000-01-01 06:28:00 UTC")],
        ["DADAN", 1, t("2000-01-01 06:37:00 UTC"), t("2000-01-01 06:35:00 UTC")],
        ["NADAV", 2, t("2000-01-01 06:44:00 UTC"), t("2000-01-01 06:42:00 UTC")],
        ["NANAA", 3, t("2000-01-01 06:51:00 UTC"), t("2000-01-01 06:49:00 UTC")],
        ["STAGECOACH", 4, t("2000-01-01 06:58:00 UTC"), t("2000-01-01 06:56:00 UTC")],
        ["BEATTY_AIRPORT", 0, t("2000-01-01 08:00:00 UTC"), t("2000-01-01 08:00:00 UTC")],
        ["BULLFROG", 1, t("2000-01-01 08:15:00 UTC"), t("2000-01-01 08:10:00 UTC")],
        ["BULLFROG", 0, t("2000-01-01 12:05:00 UTC"), t("2000-01-01 12:05:00 UTC")],
        ["BEATTY_AIRPORT", 1, t("2000-01-01 12:15:00 UTC"), t("2000-01-01 12:15:00 UTC")],
        ["BULLFROG", 0, t("2000-01-01 08:20:00 UTC"), t("2000-01-01 08:20:00 UTC")],
        ["FUR_CREEK_RES", 1, t("2000-01-01 09:20:00 UTC"), t("2000-01-01 09:20:00 UTC")],
        ["FUR_CREEK_RES", 0, t("2000-01-01 11:00:00 UTC"), t("2000-01-01 11:00:00 UTC")],
        ["BULLFROG", 1, t("2000-01-01 12:00:00 UTC"), t("2000-01-01 12:00:00 UTC")],
        ["BEATTY_AIRPORT", 0, t("2000-01-01 08:00:00 UTC"), t("2000-01-01 08:00:00 UTC")],
        ["AMV", 1, t("2000-01-01 09:00:00 UTC"), t("2000-01-01 09:00:00 UTC")],
        ["AMV", 0, t("2000-01-01 10:00:00 UTC"), t("2000-01-01 10:00:00 UTC")],
        ["BEATTY_AIRPORT", 1, t("2000-01-01 11:00:00 UTC"), t("2000-01-01 11:00:00 UTC")],
        ["BEATTY_AIRPORT", 0, t("2000-01-01 13:00:00 UTC"), t("2000-01-01 13:00:00 UTC")],
        ["AMV", 1, t("2000-01-01 14:00:00 UTC"), t("2000-01-01 14:00:00 UTC")],
        ["AMV", 0, t("2000-01-01 15:00:00 UTC"), t("2000-01-01 15:00:00 UTC")],
        ["BEATTY_AIRPORT", 1, t("2000-01-01 16:00:00 UTC"), t("2000-01-01 16:00:00 UTC")]
      ]
      expect(referential.vehicle_journey_at_stops.includes(stop_point: :stop_area).pluck(*defined_attributes)).to eq(expected_attributes)
    end
  end

end
