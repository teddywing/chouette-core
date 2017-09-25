RSpec.describe 'ReferentialSuites', type: :feature do

  login_user

  let(:workbench) { create :workbench }
  let!(:referential_suite) { create :referential_suite }

  describe 'index' do
    before(:each) { visit workbench_output_path(workbench) }

    it 'has a page ;)' do
      require 'pry'; binding.pry
      expect( page ).to be_true

    end

  end
end
