require 'rails_helper'

RSpec.describe Workgroup, type: :model do
  context "associations" do
    let( :workgroup ){ build_stubbed :workgroup, line_referential_id: 53, stop_area_referential_id: 42 }

    it{ should have_many(:workbenches) }
    it{ should validate_uniqueness_of(:name) }
    it{ should validate_uniqueness_of(:stop_area_referential_id) }
    it{ should validate_uniqueness_of(:line_referential_id) }

    it 'is not valid without a stop_area_referential' do
      workgroup.stop_area_referential_id = nil
      expect( workgroup ).not_to be_valid
    end
    it 'is not valid without a line_referential' do
      workgroup.line_referential_id = nil
      expect( workgroup ).not_to be_valid
    end
    it 'is valid with both assoications' do
      expect( workgroup ).to be_valid
    end
  end

  context "find organisations" do
    let( :workgroup ){ create :workgroup }
    let!( :workbench1 ){ create :workbench, workgroup: workgroup }
    let!( :workbench2 ){ create :workbench, workgroup: workgroup }

    it{ expect( Set.new(workgroup.organisations) ).to eq(Set.new([ workbench1.organisation, workbench2.organisation ])) }
  end
end
