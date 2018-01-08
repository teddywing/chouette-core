require 'rails_helper'

RSpec.describe Workgroup, type: :model do
  let( :workgroup ){ build_stubbed :workgroup }

  it 'is not valid without a stop_area_referential' do
    workgroup.line_referential_id = 42
    expect( workgroup ).not_to be_valid
  end
end
