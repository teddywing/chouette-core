class AccessLinkPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    !archived? && oragnisation_mathc? && user.has_permission?('access_links.create')
  end

  def update?
    !archived? && organisation_match? && user.has_permission?('access_links.edit')
  end

  def destroy?
    !archived? && organisation_match? && user.has_permission?('access_links.destroy')
  end
end
