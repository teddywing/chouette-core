class RoutingConstraintZonePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    user.has_permission?('routing_constraint_zones.create')
  end

  def edit?
    user.has_permission?('routing_constraint_zones.edit')
  end

  def destroy?
    user.has_permission?('routing_constraint_zones.destroy')
  end

  def update?  ; edit? end
  def new?     ; create? end
end
