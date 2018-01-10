class JourneyPatternPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    !referential_read_only? && organisation_match? && user.has_permission?('journey_patterns.create')
  end

  def destroy?
    !referential_read_only? && organisation_match? && user.has_permission?('journey_patterns.destroy')
  end

  def update?
    !referential_read_only? && organisation_match? && user.has_permission?('journey_patterns.update')
  end
end
