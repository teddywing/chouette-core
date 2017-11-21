RSpec.describe 'ReferentialSuites', type: :feature do

  login_user

  let(:workbench) { create :workbench }
  let(:referential_suite) { workbench.output }
  let(:referentials) do
    3.times.map { |_| create :referential, workbench_id: workbench.id, referential_suite_id: referential_suite.id }
  end
  let( :referential ){ referentials.first }


  describe 'index' do
    context 'no referentials present' do
      before(:each) do
        require 'pry'; binding.pry
        visit workbench_output_path(workbench)
      end
      it 'has a page with the correct information' do
        # Breadcrumb
        expect( page ).to have_text('Accueil')
        expect( page ).to have_text("Gestion de l'offre")

        # Title
        expect( page ).to have_text('Offres de mon organisation')
      end

    end

    context 'referentials present' do
      before(:each) do
        referentials
        visit workbench_output_path(workbench)
      end

      it 'has a page with the correct information' do
        # Breadcrumb
        expect( page ).to have_text('Accueil')
        expect( page ).to have_text("Gestion de l'offre")

        # Title
        expect( page ).to have_text('Offres de mon organisation')
      end

      xit 'filtering with Ransack' do
        fill_in 'q[status]', with: 'Courant'

      end

    end
  end
end
