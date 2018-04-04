class RoutePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    !referential_read_only? && organisation_match? && user.has_permission?('routes.create')
  end

  def destroy?
    !referential_read_only? && organisation_match? && user.has_permission?('routes.destroy')
  end

  def update?
    !referential_read_only? && organisation_match? && user.has_permission?('routes.update')
  end

  def duplicate?
    create?
  end

  def create_opposite?
    create?
  end
end
