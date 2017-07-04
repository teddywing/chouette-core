class RoutingConstraintZonePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    !archived? && user.has_permission?('routing_constraint_zones.create') # organisation match via referential is checked in the view
  end

  def destroy?
    !archived? && organisation_match? && user.has_permission?('routing_constraint_zones.destroy')
  end

  def update?
    !archived? && organisation_match? && user.has_permission?('routing_constraint_zones.edit')
  end
end
