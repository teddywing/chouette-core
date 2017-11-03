RSpec.describe "ComplianceCheckSets", type: :feature do

  login_user

  # We setup a control_set with two blocks and one direct control (meaning that it is not attached to a block)
  # Then we add one control to the first block and two controls to the second block
  let( :compliance_check_set ){ create :compliance_check_set }

  context 'show' do
    it 'can visit the page' do
      visit(workbench_compliance_check_set_path(compliance_check_set.workbench, compliance_check_set))
    end
  end
end
