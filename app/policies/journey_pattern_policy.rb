class JourneyPatternPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    user.has_permission?('journey_patterns.create') # organisation match via referential is checked in the view
  end

  def edit?
    organisation_match?(via_referential: true) && user.has_permission?('journey_patterns.edit')
  end

  def destroy?
    organisation_match?(via_referential: true) && user.has_permission?('journey_patterns.destroy')
  end

  def update?  ; edit? end
  def new?     ; create? end
end

