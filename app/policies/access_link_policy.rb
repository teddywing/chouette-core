class AccessLinkPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    !referential_read_only? && organisation_match? && user.has_permission?('access_links.create')
  end

  def update?
    !referential_read_only? && organisation_match? && user.has_permission?('access_links.update')
  end

  def destroy?
    !referential_read_only? && organisation_match? && user.has_permission?('access_links.destroy')
  end
end
