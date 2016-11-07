require 'rails_helper'

RSpec.describe Workbench, :type => :model do

  it 'should have a valid factory' do
    expect(FactoryGirl.build(:workbench)).to be_valid
  end

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:organisation) }

  it { should belong_to(:organisation) }
  it { should belong_to(:line_referential) }
  it { should belong_to(:stop_area_referential) }

  it { should have_many(:lines).through(:line_referential) }
  it { should have_many(:networks).through(:line_referential) }
  it { should have_many(:companies).through(:line_referential) }
  it { should have_many(:group_of_lines).through(:line_referential) }

  it { should have_many(:stop_areas).through(:stop_area_referential) }
end
