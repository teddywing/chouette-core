  class AccessPointPolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        scope
      end
    end

    def create?
      !archived? && organisation_match? && user.has_permission?('access_points.create')
    end

    def update?
      !archived? && organisation_match? && user.has_permission?('access_points.update')
    end

    def destroy?
      !archived? && organisation_match? && user.has_permission?('access_points.destroy')
    end
  end
