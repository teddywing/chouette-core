class RoutePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    !archived? && user.has_permission?('routes.create') # organisation match via referential is checked in the view
  end

  def destroy?
    !archived? && organisation_match? && user.has_permission?('routes.destroy')
  end

  def update?
    !archived? && organisation_match? && user.has_permission?('routes.update')
  end
end
