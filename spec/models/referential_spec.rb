require 'spec_helper'

describe Referential, :type => :model do
  let(:ref) { create :referential }

  # it "create a rule_parameter_set" do
    # referential = create(:referential)
    #expect(referential.rule_parameter_sets.size).to eq(1)
  # end

  it { should have_many(:referential_metadatas) }
  it { should belong_to(:workbench) }

  context "Cloning referential" do
    let(:cloned) { create(:referential, created_from: ref) }

    it 'should create a ReferentialCloning' do
      expect { cloned }.to change{ReferentialCloning.count}.by(1)
    end

    it 'should clone referential_metadatas' do
      expect(cloned.referential_metadatas).not_to be_empty
    end
  end
end
