require 'spec_helper'

RSpec.describe Chouette::Route, :type => :model do
  subject(:route){ create :route }
  context "metadatas" do
    it "should be empty at first" do
      expect(Chouette::Route.has_metadata?).to be_truthy
      expect(route.has_metadata?).to be_truthy
      expect(route.metadata.creator_username).to be_nil
      expect(route.metadata.modifier_username).to be_nil
    end

    context "once set" do
      it "should set the correct values" do
        Timecop.freeze(Time.now) do
          route.metadata.creator_username = "john.doe"
          route.save!
          id = route.id
          route = Chouette::Route.find id
          expect(route.metadata.creator_username).to eq "john.doe"
          expect(route.metadata.creator_username_updated_at.strftime('%Y-%m-%d %H:%M:%S.%3N')).to eq Time.now.strftime('%Y-%m-%d %H:%M:%S.%3N')
        end
      end
    end
  end
end
