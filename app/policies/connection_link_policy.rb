class ConnectionLinkPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    !archived_or_finalised? && organisation_match? && user.has_permission?('connection_links.create')
  end

  def destroy?
    !archived_or_finalised? && organisation_match? && user.has_permission?('connection_links.destroy')
  end

  def update?
    !archived_or_finalised? && organisation_match? && user.has_permission?('connection_links.update')
  end
end
