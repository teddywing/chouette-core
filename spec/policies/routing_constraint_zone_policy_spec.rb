RSpec.describe RoutingConstraintZonePolicy, type: :policy do

  let( :record ){ build_stubbed :routing_constraint_zone }


  permissions :create? do
    it_behaves_like 'permitted policy and same organisation', 'routing_constraint_zones.create', archived: true
  end

  permissions :destroy? do
    it_behaves_like 'permitted policy and same organisation', 'routing_constraint_zones.destroy', archived: true
  end

  permissions :edit? do
    it_behaves_like 'permitted policy and same organisation', 'routing_constraint_zones.edit', archived: true
  end

  permissions :new? do
    it_behaves_like 'permitted policy and same organisation', 'routing_constraint_zones.create', archived: true
  end

  permissions :update? do
    it_behaves_like 'permitted policy and same organisation', 'routing_constraint_zones.edit', archived: true
  end
end
