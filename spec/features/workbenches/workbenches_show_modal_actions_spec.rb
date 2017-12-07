RSpec.describe 'Workbenches', type: [:feature, :poltergeist] do
  login_user

  let(:line_ref) { create :line_referential }
  let(:line) { create :line, line_referential: line_ref }
  let(:ref_metadata) { create(:referential_metadata, lines: [line]) }

  let(:workbench) { create :workbench, line_referential: line_ref, organisation: @user.organisation }
  let!(:referential) { create :workbench_referential,
                              workbench: workbench,
                              metadatas: [ref_metadata],
                              organisation: @user.organisation }
  

  describe 'show' do
    context 'modal action' do
      it 'expected behavior' do
        visit workbench_path(workbench)
      
        # Modal Action Box: is present
        within( :css, ".select_toolbox#selected-referentials-action-box span.info-msg > span") do
          expect( page ).to have_content("0")
        end
        
      end
    end
  end

end
