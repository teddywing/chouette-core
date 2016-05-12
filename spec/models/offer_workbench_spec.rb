require 'rails_helper'

RSpec.describe OfferWorkbench, :type => :model do

  it 'should have a valid factory' do
    expect(FactoryGirl.build(:offer_workbench)).to be_valid
  end

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
  it { should validate_presence_of(:organisation) }

end
