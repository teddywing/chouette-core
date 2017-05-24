class RoutingConstraintZonePolicy < BoivPolicy
  extend Policies::Chain
  class Scope < Scope
    def resolve
      scope
    end
  end

  chain_policies :archived?, :!, policies: %i{create? destroy? edit?}

  def create?
    user.has_permission?('routing_constraint_zones.create') # organisation match via referential is checked in the view
  end

  def edit?
    organisation_match? && user.has_permission?('routing_constraint_zones.edit')
  end

  def destroy?
    organisation_match? && user.has_permission?('routing_constraint_zones.destroy')
  end

  def update?  ; edit? end
  def new?     ; create? end
end
