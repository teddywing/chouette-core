class ConnectionLinkPolicy < BoivPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    user.has_permission?('connection_links.create') # organisation match via referential is checked in the view
  end

  def edit?
    organisation_match? && user.has_permission?('connection_links.edit')
  end

  def destroy?
    organisation_match? && user.has_permission?('connection_links.destroy')
  end

  def update?  ; edit? end
  def new?     ; create? end
end
