describe "Merges", :type => :feature do
  login_user

  describe 'permissions' do
    before do
      allow_any_instance_of(MergePolicy).to receive(:create?).and_return permission
      visit path
    end

    describe 'on show view' do
      let( :path ){ workbench_output_path(referential.workbench) }
      let(:button_text) { I18n.t('merges.actions.create') }

      context 'if present → ' do
        let( :permission ){ true }
        it 'view shows the corresponding buttons' do
          expected_new_url   = new_workbench_merge_path(referential.workbench)
          expect( page ).to have_link(button_text, href: expected_new_url)
        end
      end

      context 'if absent → ' do
        let( :permission ){ false }
        it 'view does not show the corresponding buttons' do
          expect( page ).not_to have_link(button_text)
        end
      end
    end

  end
end
