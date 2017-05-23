RSpec.describe TimeTablePolicy, type: :policy do

  permissions :duplicate? do
    it_behaves_like 'permitted policy and same organisation', 'time_tables.create', restricted_ready: true
  end

  %w{destroy edit}.each do | permission |
    permissions "#{permission}?".to_sym do
      it_behaves_like 'permitted policy and same organisation', "time_tables.#{permission}", restricted_ready: true
    end
  end

  permissions :create? do
    it_behaves_like 'permitted policy', 'time_tables.create', restricted_ready: true
  end


end
