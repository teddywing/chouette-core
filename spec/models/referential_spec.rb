require 'spec_helper'

describe Referential, :type => :model do
  let(:ref) { create :referential }

  # it "create a rule_parameter_set" do
    # referential = create(:referential)
    #expect(referential.rule_parameter_sets.size).to eq(1)
  # end

  it { should have_one(:referential_metadata) }
  it { should belong_to(:workbench) }

  it 'should create a ReferentialCloning when a referential is cloned' do
    expect { create(:referential, created_from: ref) }.to change{ReferentialCloning.count}.by(1)
  end
end
