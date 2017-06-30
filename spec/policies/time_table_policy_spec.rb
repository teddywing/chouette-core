RSpec.describe TimeTablePolicy, type: :policy do

  let( :record ){ build_stubbed :time_table }


  permissions :duplicate? do
    it_behaves_like 'permitted policy and same organisation', 'time_tables.create', archived: true
  end

  %w{destroy edit}.each do | permission |
    permissions "#{permission}?".to_sym do
      it_behaves_like 'permitted policy and same organisation', "time_tables.#{permission}", archived: true
    end
  end

  permissions :create? do
    it_behaves_like 'permitted policy', 'time_tables.create', archived: true
  end


end
