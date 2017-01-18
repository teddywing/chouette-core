class JourneyPatternPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    user.has_permission?('journey_patterns.create')
  end

  def edit?
    user.has_permission?('journey_patterns.edit')
  end

  def destroy?
    user.has_permission?('journey_patterns.destroy')
  end

  def update?  ; edit? end
  def new?     ; create? end
end
