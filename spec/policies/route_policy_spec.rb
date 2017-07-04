RSpec.describe RoutePolicy, type: :policy do

  let( :record ){ build_stubbed :route }

  permissions :create? do
    it_behaves_like 'permitted policy', 'routes.create', archived: true
  end

  permissions :destroy? do
    it_behaves_like 'permitted policy and same organisation', 'routes.destroy', archived: true
  end

  permissions :edit? do
    it_behaves_like 'permitted policy and same organisation', 'routes.edit', archived: true
  end

  permissions :new? do
    it_behaves_like 'permitted policy', 'routes.create', archived: true
  end

  permissions :update? do
    it_behaves_like 'permitted policy and same organisation', 'routes.edit', archived: true
  end
end
