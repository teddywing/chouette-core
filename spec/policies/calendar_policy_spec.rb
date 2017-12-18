RSpec.describe CalendarPolicy, type: :policy do

  let( :record ){ build_stubbed :calendar }
  before { stub_policy_scope(record) }


  permissions :create? do
    it_behaves_like 'permitted policy', 'calendars.create', archived: true
  end
  permissions :share? do
    it_behaves_like 'permitted policy and same organisation', 'calendars.share', archived: true
  end
  permissions :destroy? do
    it_behaves_like 'permitted policy and same organisation', 'calendars.destroy', archived: true
  end
  permissions :edit? do
    it_behaves_like 'permitted policy and same organisation', 'calendars.update', archived: true
  end
  permissions :new? do
    it_behaves_like 'permitted policy', 'calendars.create', archived: true
  end
  permissions :update? do
    it_behaves_like 'permitted policy and same organisation', 'calendars.update', archived: true
  end
end
