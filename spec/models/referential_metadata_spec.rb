require 'rails_helper'

RSpec.describe ReferentialMetadata, :type => :model do

  it { should belong_to(:referential) }
  it { should belong_to(:referential_source) }

  it { is_expected.to validate_presence_of(:referential) }
  it { is_expected.to validate_presence_of(:lines) }
  it { is_expected.to validate_presence_of(:periodes) }

  describe ".new_from" do

    let(:referential_metadata) { create :referential_metadata, referential_source: create(:referential) }
    let(:new_referential_metadata) { ReferentialMetadata.new_from(referential_metadata) }

    it "should not have an associated referential" do
      expect(new_referential_metadata).to be_a_new(ReferentialMetadata)
    end

    it "should have the same lines" do
      expect(new_referential_metadata.lines).to eq(referential_metadata.lines)
    end

    it "should have the same periods" do
      expect(new_referential_metadata.periodes).to eq(referential_metadata.periodes)
    end

    it "should not have an associated referential" do
      expect(new_referential_metadata.referential).to be(nil)
    end

    it "should have the same referential_source" do
      expect(new_referential_metadata.referential_source).to eq(referential_metadata.referential_source)
    end

  end

  describe "#includes_lines" do

    let(:referential_metadata) { create :referential_metadata }

    it "should find ReferentialMetadata associated with given Line" do
      expect(ReferentialMetadata.include_lines(referential_metadata.lines)).to eq([referential_metadata])
    end

  end

end
