RSpec.describe PurchaseWindowPolicy, type: :policy do

  let( :record ){ build_stubbed :purchase_window }
  before { stub_policy_scope(record) }

  permissions :create? do
    it_behaves_like 'permitted policy and same organisation', "purchase_windows.create", archived_and_finalised: true
  end
  permissions :destroy? do
    it_behaves_like 'permitted policy and same organisation', "purchase_windows.destroy", archived_and_finalised: true
  end
  permissions :update? do
    it_behaves_like 'permitted policy and same organisation', "purchase_windows.update", archived_and_finalised: true
  end
end
