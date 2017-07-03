# coding: utf-8

describe 'Workbenches', type: :feature do
  login_user

  let(:line_ref) { create :line_referential }
  let(:line) { create :line, line_referential: line_ref }
  let(:ref_metadata) { create(:referential_metadata, lines: [line]) }

  let!(:workbench) { create(:workbench, line_referential: line_ref, organisation: @user.organisation) }
  let!(:referential) { create :referential, workbench: workbench, metadatas: [ref_metadata], organisation: @user.organisation }

  describe 'show' do
    context 'ready' do
      it 'should show ready referentials' do
        visit workbench_path(workbench)
        expect(page).to have_content(referential.name)
      end

      it 'should not show unready referentials' do
        referential.update_attribute(:ready, false)
        visit workbench_path(workbench)
        expect(page).to_not have_content(referential.name)
      end
    end

    context 'filtering' do
      let(:another_organisation) { create :organisation }
      let(:another_line) { create :line, line_referential: line_ref }
      let(:another_ref_metadata) { create(:referential_metadata, lines: [another_line]) }
      let!(:other_referential) { create :referential, workbench: workbench, metadatas: [another_ref_metadata], organisation: another_organisation}

      before(:each) do
        visit workbench_path(workbench)
      end

      context 'without any filter' do
        it 'should have results' do
          click_button 'Filtrer'
          expect(page).to have_content(referential.name)
          expect(page).to have_content(other_referential.name)
        end
      end

      context 'filter by organisation' do
        it 'should be possible to filter by organisation' do
          find("#q_organisation_name_eq_any_#{@user.organisation.name.parameterize.underscore}").set(true)
          click_button 'Filtrer'

          expect(page).to have_content(referential.name)
          expect(page).not_to have_content(other_referential.name)
        end

        it 'should be possible to filter by multiple organisation' do
          find("#q_organisation_name_eq_any_#{@user.organisation.name.parameterize.underscore}").set(true)
          find("#q_organisation_name_eq_any_#{another_organisation.name.parameterize.underscore}").set(true)
          click_button 'Filtrer'

          expect(page).to have_content(referential.name)
          expect(page).to have_content(other_referential.name)
        end
      end
    end

    context 'permissions' do
      before(:each) do
        visit workbench_path(workbench)
      end

      context 'user has the permission to create referentials' do
        it 'shows the link for a new referetnial' do
          expect(page).to have_link(I18n.t('actions.add'), href: new_referential_path(workbench_id: workbench.id))
        end
      end

      context 'user does not have the permission to create referentials' do
        it 'does not show the clone link for referential' do
          @user.update_attribute(:permissions, [])
          visit referential_path(referential)
          expect(page).not_to have_link(I18n.t('actions.add'), href: new_referential_path(workbench_id: workbench.id))
        end
      end
    end
  end

  describe 'create new Referential' do
    it "create a new Referential with a specifed line and period" do
      referential.destroy

      visit workbench_path(workbench)
      click_link I18n.t('actions.add')
      fill_in "referential[name]", with: "Referential to test creation"
      select workbench.lines.first.id, from: 'referential[metadatas_attributes][0][lines][]'

      click_button "Valider"
      expect(page).to have_css("h1", text: "Referential to test creation")
    end
  end
end
