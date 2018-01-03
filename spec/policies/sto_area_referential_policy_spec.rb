RSpec.describe StopAreaReferentialPolicy, type: :policy do

  let( :record ){ build_stubbed :stop_area_referential }
  before { stub_policy_scope(record) }

  permissions :synchronize? do
    it_behaves_like 'permitted policy', 'stop_area_referentials.synchronize'
  end
end
