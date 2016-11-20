require 'spec_helper'

describe Referential, :type => :model do
  let(:ref) { create :referential, metadatas: [create(:referential_metadata)] }

  # it "create a rule_parameter_set" do
    # referential = create(:referential)
    #expect(referential.rule_parameter_sets.size).to eq(1)
  # end

  it { should have_many(:metadatas) }
  it { should belong_to(:workbench) }

  context "Cloning referential" do
    let(:cloned) { Referential.new_from(ref).tap(&:save!) }

    it 'should create a ReferentialCloning' do
      expect { cloned }.to change{ReferentialCloning.count}.by(1)
    end

    def metadatas_attributes(referential)
      referential.metadatas.map { |m| [ m.periodes, m.line_ids ] }
    end

    it 'should clone referential_metadatas' do
      expect(metadatas_attributes(cloned)).to eq(metadatas_attributes(ref))
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
              "first_period_begin(3i)"=>"19",
              "first_period_begin(2i)"=>"11",
              "first_period_begin(1i)"=>"2016",
              "first_period_end(3i)"=>"19",
              "first_period_end(2i)"=>"12",
              "first_period_end(1i)"=>"2016",
              "lines"=> [""] + lines.map { |l| l.id.to_s }
            }
          },
          "workbench_id"=>"1",
        }
      end

      let(:lines) { create_list(:line, 3)}

      let(:new_referential) { Referential.new(attributes) }
      let(:first_metadata) { new_referential.metadatas.first }

      it "should create a metadata" do
        expect(new_referential.metadatas.size).to eq(1)
      end

      it "should define first_period_begin" do
        expect(first_metadata.first_period_begin).to eq(Date.new(2016,11,19))
      end

      it "should define first_period_end" do
        expect(first_metadata.first_period_end).to eq(Date.new(2016,12,19))
      end

      it "should define period" do
        new_referential.save!
        expect(first_metadata.first_period).to eq(Range.new(Date.new(2016,11,19), Date.new(2016,12,19)))
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

end
