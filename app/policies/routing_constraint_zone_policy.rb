class RoutingConstraintZonePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    !archived_or_finalised? && organisation_match? && user.has_permission?('routing_constraint_zones.create')
  end

  def destroy?
    !archived_or_finalised? && organisation_match? && user.has_permission?('routing_constraint_zones.destroy')
  end

  def update?
    !archived_or_finalised? && organisation_match? && user.has_permission?('routing_constraint_zones.update')
  end
end
