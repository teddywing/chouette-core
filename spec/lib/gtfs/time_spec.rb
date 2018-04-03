require "rails_helper"

RSpec.describe GTFS::Time do

  it "returns an UTC Time with given H:M:S" do
    expect(GTFS::Time.parse("14:29:00").time).to eq(Time.parse("2000-01-01 14:29:00 +00"))
  end

  it "support hours with a single number" do
    expect(GTFS::Time.parse("4:29:00").time).to eq(Time.parse("2000-01-01 04:29:00 +00"))
  end

  it "return nil for invalid format" do
    expect(GTFS::Time.parse("abc")).to be_nil
  end

  it "removes 24 hours after 23:59:59" do
    expect(GTFS::Time.parse("25:29:00").time).to eq(Time.parse("2000-01-01 01:29:00 +00"))
  end

  it "returns a day_offset for each 24 hours turn" do
    expect(GTFS::Time.parse("10:00:00").day_offset).to eq(0)
    expect(GTFS::Time.parse("30:00:00").day_offset).to eq(1)
    expect(GTFS::Time.parse("50:00:00").day_offset).to eq(2)
  end

end
