class RoutePolicy < BoivPolicy
  extend Policies::Chain
  class Scope < Scope
    def resolve
      scope
    end
  end

  chain_policies :archived?, :!, policies: %i{create? destroy? edit?}

  def create?
    user.has_permission?('routes.create') # organisation match via referential is checked in the view
  end

  def edit?
    organisation_match? && user.has_permission?('routes.edit')
  end

  def destroy?
    organisation_match? && user.has_permission?('routes.destroy')
  end

  def update?  ; edit? end
  def new?     ; create? end
end
