class ConnectionLinkPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    user.has_permission?('connection_links.create') # organisation match via referential is checked in the view
  end

  def destroy?
    organisation_match? && user.has_permission?('connection_links.destroy')
  end

  def update?
    organisation_match? && user.has_permission?('connection_links.edit')
  end
end
