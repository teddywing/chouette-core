class RoutePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    !archived_or_finalised? && organisation_match? && user.has_permission?('routes.create')
  end

  def destroy?
    !archived_or_finalised? && organisation_match? && user.has_permission?('routes.destroy')
  end

  def update?
    !archived_or_finalised? && organisation_match? && user.has_permission?('routes.update')
  end

  def duplicate?
    create?
  end
end
