require 'spec_helper'

describe 'Workbenches', type: :feature do
  login_user

  let!(:organisations) { Array.new(2) { create :organisation } }
  let!(:referentials) { Array.new(2) { create :referential, ready: true } }
  let!(:line_referential) { create :line_referential }
  let!(:workbenches) { Array.new(2) { create :workbench, line_referential: line_referential } }
  let!(:line) { create :line, line_referential: line_referential }
  let!(:referential_metadatas) { Array.new(2) { |i| create :referential_metadata, lines: [line], referential: referentials[i] } }

  let!(:ready_referential) { create(:referential, workbench: workbenches.first, ready: true) }
  let!(:unready_referential) { create(:referential, workbench: workbenches.first) }

  describe 'show' do
    it 'shows ready referentials belonging to that workbench by default' do
      visit workbench_path(workbenches.first)
      expect(page).to have_content(ready_referential.name)
      expect(page).not_to have_content(unready_referential.name)
    end

    it 'shows all ready referentials if that option is chosen' do
      visit workbench_path(workbenches.first)
      click_link I18n.t('referentials.show.show_all_referentials')
      expect(page).to have_content(referentials.first.name)
      expect(page).to have_content(referentials.last.name)
    end
  end
end
