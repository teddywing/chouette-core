require 'rails_helper'

RSpec.describe ReferentialCloning, :type => :model do
  it 'should have a valid factory' do
    expect(FactoryGirl.build(:referential_cloning)).to be_valid
  end

  it { should belong_to :source_referential }
  it { should belong_to :target_referential }
end
