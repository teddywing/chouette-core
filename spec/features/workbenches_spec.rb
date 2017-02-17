require 'spec_helper'

describe 'Workbenches', type: :feature do
  login_user

  let!(:organisations) { Array.new(2) { create :organisation } }
  let!(:referentials) { Array.new(2) { create :referential, ready: true } }
  let!(:line_referential) { create :line_referential }
  let!(:workbenches) { Array.new(2) { create :workbench, line_referential: line_referential, organisation: @user.organisation } }
  let!(:line) { create :line, line_referential: line_referential }
  let!(:referential_metadatas) { Array.new(2) { |i| create :referential_metadata, lines: [line], referential: referentials[i] } }

  let!(:ready_referential) { create(:referential, workbench: workbenches.first, metadatas: referential_metadatas, ready: true, organisation: @user.organisation) }
  let!(:unready_referential) { create(:referential, workbench: workbenches.first) }

  describe 'show' do
    it 'shows ready referentials belonging to that workbench by default' do
      visit workbench_path(workbenches.first)
      expect(page).to have_content(ready_referential.name)
      expect(page).not_to have_content(unready_referential.name)
    end
  end
end
