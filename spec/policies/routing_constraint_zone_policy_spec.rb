RSpec.describe RoutingConstraintZonePolicy, type: :policy do

  permissions :create? do
    it_behaves_like 'permitted policy', 'routing_constraint_zones.create', restricted_ready: true
  end

  permissions :destroy? do
    it_behaves_like 'permitted policy and same organisation', 'routing_constraint_zones.destroy', restricted_ready: true
  end

  permissions :edit? do
    it_behaves_like 'permitted policy and same organisation', 'routing_constraint_zones.edit', restricted_ready: true
  end

  permissions :new? do
    it_behaves_like 'permitted policy', 'routing_constraint_zones.create', restricted_ready: true
  end

  permissions :update? do
    it_behaves_like 'permitted policy and same organisation', 'routing_constraint_zones.edit', restricted_ready: true
  end
end
