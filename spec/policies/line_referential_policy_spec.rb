RSpec.describe LineReferentialPolicy, type: :policy do

  let( :record ){ build_stubbed :line_referential }
  before { stub_policy_scope(record) }

  permissions :synchronize? do
    it_behaves_like 'permitted policy', 'line_referentials.synchronize'
  end
end
