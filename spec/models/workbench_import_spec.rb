RSpec.describe WorkbenchImport do
  let( :workbench_import ){ build_stubbed :workbench_import }

  it 'is valid' do
    expect( workbench_import ).to be_valid
  end

  it 'or not...' do
    expect( build_stubbed :workbench_import, status: 'what?' ).not_to be_valid
  end

end
