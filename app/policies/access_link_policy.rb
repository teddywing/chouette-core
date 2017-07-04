class AccessLinkPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    user.has_permission?('access_links.create') # organisation match via referential is checked in the view
  end

  def update?
    organisation_match? && user.has_permission?('access_links.edit')
  end

  def destroy?
    organisation_match? && user.has_permission?('access_links.destroy')
  end
end
