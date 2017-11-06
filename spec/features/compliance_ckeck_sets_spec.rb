RSpec.describe "ComplianceCheckSets", type: :feature do

  include ComplianceCheckSetsHelper

  login_user

  # We setup a control_set with two blocks and one direct control (meaning that it is not attached to a block)
  # Then we add one control to the first block and two controls to the second block
  let( :compliance_check_set ){ create :compliance_check_set, name: random_string }
  let!(:direct_checks){ make_check(nil, times: 2) + make_check(nil, severity: :error) }

  context 'show' do
    before do
      visit(compliance_check_set_path(compliance_check_set))
    end

    it 'we can see the expected content' do
      # Breadcrumbs
      expect_breadcrumb_links "Accueil", "Gestion de l'offre", " Rapports de contrôle"

      # Headline
      expect( page ).to have_content("Rapport de contrôle #{compliance_check_set.name}")

      # Information Definition List
      expect( page.first('.dl-term') ).to have_content("Nom")
      expect( page.first('.dl-def') ).to have_content(compliance_check_set.name)

      # Filters
      within( 'form.form-filter' ) do
        expect( page ).to have_content("Objét")
        expect( page ).to have_content("Criticité")
      end
      

      # Checks
    end
  end

  def make_check ccblock=nil, times: 1, severity: :error
    times.times.map do
      make_one_check ccblock, severity
    end
  end

  def make_one_check ccblock, severity
    create( :compliance_check,
           code: random_string,
           compliance_check_block: ccblock,
           compliance_check_set: compliance_check_set,
           criticity: severity)
  end
end
