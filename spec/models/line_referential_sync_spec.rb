require 'rails_helper'

RSpec.describe LineReferentialSync, :type => :model do
  it 'should have a valid factory' do
    expect(FactoryGirl.build(:line_referential_sync)).to be_valid
  end
  it { is_expected.to belong_to(:line_referential) }
end
