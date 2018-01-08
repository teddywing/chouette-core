class JourneyPatternPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    !archived_or_finalised? && organisation_match? && user.has_permission?('journey_patterns.create')
  end

  def destroy?
    !archived_or_finalised? && organisation_match? && user.has_permission?('journey_patterns.destroy')
  end

  def update?
    !archived_or_finalised? && organisation_match? && user.has_permission?('journey_patterns.update')
  end
end
