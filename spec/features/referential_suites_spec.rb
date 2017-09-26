RSpec.describe 'ReferentialSuites', type: :feature do

  login_user

  let(:workbench) { create :workbench }
  let(:referential_suite) { workbench.output }
  let!(:referentials) do
    3.times.map { |_| create :referential, workbench: workbench, referential_suite: referential_suite }
  end

  describe 'index' do
    before(:each) { visit workbench_output_path(workbench) }

    it 'has a page with the correct information' do
      # Breadcrumb
      expect( page ).to have_text('Accueil')
      expect( page ).to have_text("Gestion de l'offre")

      # Title
      expect( page ).to have_text('Offres de mon organisation')
    end

    it 'filtering with Ransack' do
      fill_in 'q[name_or_objectid_cont]', with: referential_suite.name
      
    end

  end
end
