class RoutePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    user.has_permission?('routes.create')
  end

  def edit?
    user.has_permission?('routes.edit')
  end

  def destroy?
    user.has_permission?('routes.destroy')
  end

  def update?  ; edit? end
  def new?     ; create? end
end
