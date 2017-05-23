RSpec.describe TimeTablePolicy, type: :policy do

  permissions :duplicate? do
    it_behaves_like 'permitted and same organisation', 'time_tables.create'
  end

end
