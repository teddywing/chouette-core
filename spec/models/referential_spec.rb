require 'spec_helper'

describe Referential, :type => :model do
  let(:ref) { create :workbench_referential, metadatas: [create(:referential_metadata)] }

  it { should have_many(:metadatas) }
  it { should belong_to(:workbench) }
  it { should belong_to(:referential_suite) }

  context "validation" do
    subject { build_stubbed(:referential) }

    it { should validate_presence_of(:objectid_format) }
  end

  context ".referential_ids_in_periode" do
    it 'should retrieve referential id in periode range' do
      range = ref.metadatas.first.periodes.sample
      refs  = Referential.referential_ids_in_periode(range)
      expect(refs).to include(ref.id)
    end

    it 'should not retrieve referential id not in periode range' do
      range = Date.today - 2.year..Date.today - 1.year
      refs  = Referential.referential_ids_in_periode(range)
      expect(refs).to_not include(ref.id)
    end
  end

  context "Cloning referential" do
    let(:clone) do
      Referential.new_from(ref, [])
    end

    # let(:saved_clone) do
    #   clone.tap do |clone|
    #     clone.organisation = ref.organisation
    #     clone.metadatas.each do |metadata|
    #       metadata.line_ids = ref.lines.where(id: clone.line_ids, objectid: JSON.parse(ref.organisation.sso_attributes["functional_scope"]).collect(&:id)
    #       metadata.periodes = metadata.periodes.map { |period| Range.new(period.end+1, period.end+10) }
    #     end
    #     clone.save!
    #   end
    # end

    xit 'should create a ReferentialCloning' do
      expect { saved_clone }.to change{ReferentialCloning.count}.by(1)
    end

    def metadatas_attributes(referential)
      referential.metadatas.map { |m| [ m.periodes, m.line_ids ] }
    end

    xit 'should clone referential_metadatas' do
      expect(metadatas_attributes(clone)).to eq(metadatas_attributes(ref))
    end
  end

  describe "metadatas" do
    context "nested attributes support" do
      let(:attributes) do
        {
          "organisation_id" => first_organisation.id,
          "name"=>"Test",
          "slug"=>"test",
          "prefix"=>"test",
          "time_zone"=>"American Samoa",
          "upper_corner"=>"51.1,8.23",
          "lower_corner"=>"42.25,-5.2",
          "data_format"=>"neptune",
          "metadatas_attributes"=> {
            "0"=> {
              "periods_attributes" => {
                "0" => {
                  "begin"=>"2016-09-19",
                  "end" => "2016-10-19",
                },
                "15918593" => {
                  "begin"=>"2016-11-19",
                  "end" => "2016-12-19",
                },
              },
              "lines"=> [""] + lines.map { |l| l.id.to_s }
            }
          },
          "workbench_id"=>"1",
        }
      end

      let(:lines) { create_list(:line, 3)}

      let(:new_referential) { Referential.new(attributes) }
      let(:first_metadata) { new_referential.metadatas.first }

      let(:expected_ranges) do
        [
          Range.new(Date.new(2016,9,19), Date.new(2016,10,19)),
          Range.new(Date.new(2016,11,19), Date.new(2016,12,19)),
        ]
      end

      it "should create a metadata" do
        expect(new_referential.metadatas.size).to eq(1)
      end

      it "should define metadata periods" do
        expect(first_metadata.periods.map(&:range)).to eq(expected_ranges)
      end

      it "should define periodes" do
        new_referential.save!
        expect(first_metadata.periodes).to eq(expected_ranges)
      end

      it "should define period" do
        new_referential.save!
        expect(first_metadata.lines).to eq(lines)
      end
    end
  end

  context "lines" do
    describe "search" do
      it "should support Ransack search method" do
        expect(ref.lines.search.result.to_a).to eq(ref.lines.to_a)
      end
    end
  end

  context "when two identical Referentials are created, only one is saved" do
    # TODO: Rename js: true to no transaction something
    it "works synchronously" do
      begin
        workbench = create(:workbench)
        referential_1 = build(
          :referential,
          workbench: workbench,
          organisation: workbench.organisation
        )
        referential_2 = referential_1.dup
        referential_2.slug = "#{referential_1.slug}_different"

        metadata_1 = build(
          :referential_metadata,
          referential: referential_1
        )
        metadata_2 = metadata_1.dup
        metadata_2.referential = referential_2

        referential_1.metadatas << metadata_1
        referential_2.metadatas << metadata_2

        referential_1.save
        referential_2.save

        expect(referential_1).to be_persisted
        expect(referential_2).not_to be_persisted
      ensure
        Apartment::Tenant.drop(referential_1.slug) if referential_1.persisted?
        Apartment::Tenant.drop(referential_2.slug) if referential_2.persisted?
      end
    end
  end
end
