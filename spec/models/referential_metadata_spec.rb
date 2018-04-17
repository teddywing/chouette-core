require 'rails_helper'

RSpec.describe ReferentialMetadata, :type => :model do

  it { should belong_to(:referential) }
  it { should belong_to(:referential_source) }

  it { is_expected.to validate_presence_of(:referential) }
  it { is_expected.to validate_presence_of(:lines) }
  it { is_expected.to validate_presence_of(:periodes) }

  describe ".new_from" do
    let(:line_referential){ create :line_referential }
    let(:workbench){ create :workbench, line_referential: line_referential}
    let(:referential){ create :workbench_referential, workbench: workbench, line_referential: line_referential }
    let(:referential_metadata) { create :referential_metadata, referential: referential }
    let(:new_referential_metadata) { ReferentialMetadata.new_from(referential_metadata, referential.workbench) }
    before do
      Workgroup.workbench_scopes_class = WorkbenchScopes::All
      referential_metadata.line_ids.each do |id|
        Chouette::Line.find(id).update_attribute :line_referential_id, line_referential.id
      end
    end

    it "should not have an associated referential" do
      expect(new_referential_metadata).to be_a_new(ReferentialMetadata)
    end

    it "should have the same lines" do
      expect(new_referential_metadata.line_ids.sort).to eq(referential_metadata.line_ids.sort)
    end

    it "should have the same periods" do
      expect(new_referential_metadata.periodes).to eq(referential_metadata.periodes)
    end

    it "should not have an associated referential" do
      expect(new_referential_metadata.referential).to be(nil)
    end

    it "should have the right referential_source" do
      expect(new_referential_metadata.referential_source).to eq(referential_metadata.referential)
    end

    context "with a functional scope" do
      let(:organisation){ create :organisation, sso_attributes: {"functional_scope" => [referential_metadata.referential.lines.first.objectid]} }
      let(:new_referential_metadata) { ReferentialMetadata.new_from(referential_metadata, referential.workbench) }
      before do
        referential.workbench.update organisation: organisation
        Workgroup.workbench_scopes_class = Stif::WorkbenchScopes
      end

      it "should scope the lines" do
        expect(new_referential_metadata.line_ids).to eq [referential_metadata.referential.lines.first.id]
      end
    end
  end

  describe "Period" do

    subject { period }

    def period(attributes = {})
      return @period if attributes.empty? and @period
      ReferentialMetadata::Period.new(attributes).tap do |period|
        @period = period if attributes.empty?
      end
    end

    it "should support mark_for_destruction (required by cocoon)" do
      period.mark_for_destruction
      expect(period).to be_marked_for_destruction
    end

    it "should support _destroy attribute (required by coocon)" do
      period._destroy = true
      expect(period).to be_marked_for_destruction
    end

    it "should support new_record? (required by cocoon)" do
      expect(ReferentialMetadata::Period.new).to be_new_record
      expect(period(id: 42)).not_to be_new_record
    end

    it "should cast begin as date attribute" do
      expect(period(begin: "2016-11-22").begin).to eq(Date.new(2016,11,22))
    end

    it "should cast end as date attribute" do
      expect(period(end: "2016-11-22").end).to eq(Date.new(2016,11,22))
    end

    it "should support multiparameter on begin attribute" do
      expect(period("begin(3i)"=>"18", "begin(2i)"=>"2", "begin(1i)"=>"2017").begin).to eq(Date.new(2017,2,18))
    end

    it "should support multiparameter on end attribute" do
      expect(period("end(3i)"=>"18", "end(2i)"=>"2", "end(1i)"=>"2017").end).to eq(Date.new(2017,2,18))
    end

    it "should ignore invalid date" do
      expect(period("end(3i)"=>"30", "end(2i)"=>"2", "end(1i)"=>"2017").end).to eq(nil)
    end

    it { is_expected.to validate_presence_of(:begin) }
    it { is_expected.to validate_presence_of(:end) }

    it "should validate that end is greather than or equlals to begin" do
      expect(period(begin: "2016-11-21", end: "2016-11-22")).to be_valid
      expect(period(begin: "2016-11-21", end: "2016-11-21")).to_not be_valid
      expect(period(begin: "2016-11-22", end: "2016-11-21")).to_not be_valid
    end

    describe "intersect?" do

      it "should detect date in common with other periods" do
        november = period(begin: "2016-11-01", end: "2016-11-30")
        mid_november_mid_december = period(begin: "2016-11-15", end: "2016-12-15")
        expect(november.intersect?(mid_november_mid_december)).to be(true)
      end

      it "should not intersect when no date is in common" do
        november = period(begin: "2016-11-01", end: "2016-11-30")
        december = period(begin: "2016-12-01", end: "2016-12-31")

        expect(november.intersect?(december)).to be(false)

        january = period(begin: "2017-01-01", end: "2017-01-31")
        expect(november.intersect?(december, january)).to be(false)
      end

      it "should not intersect itself" do
        period = period(id: 42, begin: "2016-11-01", end: "2016-11-30")
        expect(period.intersect?(period)).to be(false)
      end

    end

  end

  describe "#periodes" do

    let(:referential_metadata) { create(:referential_metadata).reload }

    it "should not exclude end" do
      expect(referential_metadata.periodes).to_not be_empty
      referential_metadata.periodes.each do |periode|
        expect(periode).to_not be_exclude_end
      end
    end

  end

  describe "before_validation" do
    let(:referential_metadata) do
      create(:referential_metadata).tap do |metadata|
        metadata.periodes = []
      end
    end

    it "shoud fill periodes with period ranges" do
      expected_ranges = [
        Range.new(Date.today, Date.tomorrow)
      ]
      expected_ranges.each_with_index do |range, index|
        referential_metadata.periods << ReferentialMetadata::Period.from_range(index, range)
      end
      referential_metadata.valid?

      expect(referential_metadata.periodes).to eq(expected_ranges)
    end
  end

  describe "#includes_lines" do

    let(:referential_metadata) { create :referential_metadata }

    it "should find ReferentialMetadata associated with given Line" do
      expect(ReferentialMetadata.include_lines(referential_metadata.lines)).to eq([referential_metadata])
    end

  end

end
