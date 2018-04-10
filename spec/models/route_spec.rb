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

    describe "#merge_metadata_from" do
      let(:source){ create :route }
      let(:metadata){ target.merge_metadata_from(source).metadata }
      let(:target){ create :route }
      before do
        target.metadata.creator_username = "john"
        target.metadata.modifier_username = "john"
      end
      context "when the source has no metadata" do
        it "should do nothing" do
          expect(metadata.creator_username).to eq "john"
          expect(metadata.modifier_username).to eq "john"
        end
      end

      context "when the source has older metadata" do
        before do
          source.metadata.creator_username = "jane"
          source.metadata.modifier_username = "jane"
          source.metadata.creator_username_updated_at = 1.month.ago
          source.metadata.modifier_username_updated_at = 1.month.ago
        end
        it "should do nothing" do
          expect(metadata.creator_username).to eq "john"
          expect(metadata.modifier_username).to eq "john"
        end
      end

      context "when the source has new metadata" do
        before do
          source.metadata.creator_username = "jane"
          source.metadata.modifier_username = "jane"
          target.metadata.creator_username_updated_at = 1.month.ago
          target.metadata.modifier_username_updated_at = 1.month.ago
        end
        it "should update metadata" do
          expect(metadata.creator_username).to eq "jane"
          expect(metadata.modifier_username).to eq "jane"
        end
      end
    end
  end
end
