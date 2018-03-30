RSpec.describe 'Calendars', type: :feature do
  login_user

  let(:calendar1)        { create(:calendar, workgroup: @user.organisation.workgroups.first, organisation: @user.organisation) }
  let(:calendar2)        { create(:calendar) }

  describe "index" do
    before(:each) do
      visit workgroup_calendars_path(calendar1.workgroup)
    end
    it "should only display calendars from same workgroup" do
      expect(page).to have_content calendar1.name
      expect(page).to_not have_content calendar2.name
    end
  end
end