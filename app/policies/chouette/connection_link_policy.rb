module Chouette
  class ConnectionLinkPolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        scope
      end
    end

    def create?
      !archived? && organisation_match? && user.has_permission?('connection_links.create')
    end

    def destroy?
      !archived? && organisation_match? && user.has_permission?('connection_links.destroy')
    end

    def update?
      !archived? && organisation_match? && user.has_permission?('connection_links.update')
    end
  end
end