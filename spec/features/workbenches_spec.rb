# coding: utf-8

describe 'Workbenches', type: :feature do
  login_user

  #let!(:organisations) { Array.new(2) { create :organisation } }
  #let!(:referentials) { Array.new(2) { create :referential, ready: true } }
  let(:line_referential) { create :line_referential }
  let(:workbenches) { Array.new(2) { create :workbench, line_referential: line_referential, organisation: @user.organisation } }
  let(:workbench) { workbenches.first }
  let!(:line) { create :line, line_referential: line_referential }

  let(:referential_metadatas) { Array.new(2) { |i| create :referential_metadata, lines: [line] } }

  describe 'show' do

    let!(:ready_referential) { create :referential, workbench: workbench, metadatas: referential_metadatas, ready: true, organisation: @user.organisation }
    let!(:unready_referential) { create :referential, workbench: workbench }

    before(:each) { visit workbench_path(workbench) }

    it 'shows ready referentials belonging to that workbench by default' do
      expect(page).to have_content(ready_referential.name)
      expect(page).not_to have_content(unready_referential.name)
    end

    context 'user has the permission to create referentials' do
      it 'shows the link for a new referetnial' do
        expect(page).to have_link(I18n.t('actions.add'), href: new_referential_path(workbench_id: workbenches.first))
      end
    end

    context 'user does not have the permission to create referentials' do
      it 'does not show the clone link for referetnial' do
        @user.update_attribute(:permissions, [])
        visit referential_path(referential)
        expect(page).not_to have_link(I18n.t('actions.add'), href: new_referential_path(workbench_id: workbenches.first))
      end
    end
  end

  describe 'create new Referential' do
    it "create a new Referential with a specifed line and period" do
      visit workbench_path(workbench)

      click_link I18n.t('actions.add')

      fill_in "referential[name]", with: "Referential to test creation" # Nom du JDD
      fill_in "referential[slug]", with: "test" # Code
      fill_in "referential[prefix]", with: "test" # Prefix Neptune
      select workbench.lines.first.id, from: 'referential[metadatas_attributes][0][lines][]' # Lignes

      click_button "Valider"
      expect(page).to have_css("h1", text: "Referential to test creation")
    end
  end
end
