require 'spec_helper'

RSpec.describe LineReferential, :type => :model do
  it 'should have a valid factory' do
    expect(FactoryGirl.build(:line_referential)).to be_valid
  end

  it { should validate_presence_of(:name) }
  it { is_expected.to have_many(:line_referential_syncs) }
  it { is_expected.to have_many(:workbenches) }
  it { should validate_presence_of(:sync_interval) }

  describe "#transport_modes" do
    it 'returns a list of all transport modes' do
      expect(FactoryGirl.create(:line_referential).transport_modes).to eq( Chouette::TransportMode.all.select { |tm| tm.to_i > 0 } )
    end
  end
end
