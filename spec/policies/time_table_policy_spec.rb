RSpec.describe TimeTablePolicy, type: :policy do

  let( :record ){ build_stubbed :time_table }


  %w{create duplicate}.each do | permission |
    permissions "#{permission}?".to_sym do
      it_behaves_like 'permitted policy and same organisation', 'time_tables.create', archived: true
    end
  end

  %w{destroy edit}.each do | permission |
    permissions "#{permission}?".to_sym do
      it_behaves_like 'permitted policy and same organisation', "time_tables.#{permission}", archived: true
    end
  end

end
