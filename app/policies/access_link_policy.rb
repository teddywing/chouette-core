  class AccessLinkPolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        scope
      end
    end

    def create?
      !archived? && organisation_match? && user.has_permission?('access_links.create')
    end

    def update?
      !archived? && organisation_match? && user.has_permission?('access_links.update')
    end

    def destroy?
      !archived? && organisation_match? && user.has_permission?('access_links.destroy')
    end
  end
