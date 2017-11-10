require 'spec_helper'

describe Chouette::Network, :type => :model do
  subject { create(:network) }
  it { should validate_presence_of :name }
  
  describe "#objectid_format" do
    it "sould not be nil" do
      expect(subject.objectid_format).not_to be_nil
    end
  end

  describe "#stop_areas" do
    let!(:line){create(:line, :network => subject)}
    let!(:route){create(:route, :line => line)}
    it "should retrieve route's stop_areas" do
      expect(subject.stop_areas.count).to eq(route.stop_points.count)
    end
  end
end
