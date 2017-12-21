RSpec.describe PurchaseWindowPolicy, type: :policy do

  let( :record ){ build_stubbed :purchase_window }
  before { stub_policy_scope(record) }

  permissions :create? do
    it_behaves_like 'permitted policy and same organisation', "purchase_windows.create", archived: true
  end
  permissions :destroy? do
    it_behaves_like 'permitted policy and same organisation', "purchase_windows.destroy", archived: true
  end
  permissions :update? do
    it_behaves_like 'permitted policy and same organisation', "purchase_windows.update", archived: true
  end
end
