class AccessLinkPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    !archived_or_finalised? && organisation_match? && user.has_permission?('access_links.create')
  end

  def update?
    !archived_or_finalised? && organisation_match? && user.has_permission?('access_links.update')
  end

  def destroy?
    !archived_or_finalised? && organisation_match? && user.has_permission?('access_links.destroy')
  end
end
