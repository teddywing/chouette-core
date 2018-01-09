class RoutingConstraintZonePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    !referential_read_only? && organisation_match? && user.has_permission?('routing_constraint_zones.create')
  end

  def destroy?
    !referential_read_only? && organisation_match? && user.has_permission?('routing_constraint_zones.destroy')
  end

  def update?
    !referential_read_only? && organisation_match? && user.has_permission?('routing_constraint_zones.update')
  end
end
