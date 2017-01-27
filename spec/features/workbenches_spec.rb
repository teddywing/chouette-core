require 'spec_helper'

describe 'Workbenches', type: :feature do
  login_user

  let!(:workbench) { create :workbench }
  let!(:ready_referential) { create(:referential, workbench: workbench, ready: true) }
  let!(:unready_referential) { create(:referential, workbench: workbench) }

  describe 'show' do
    it 'shows ready referentials belonging to that workbench' do
      visit workbench_path(workbench)
      expect(page).to have_content(ready_referential.name)
      expect(page).not_to have_content(unready_referential.name)
    end
  end
end
