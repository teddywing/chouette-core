class JourneyPatternPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    # organisation match via referential is checked in the view
    user.has_permission?('journey_patterns.create')
  end

  def edit?
    # In React UI, we don't have access to record object yet.
    # In this case record is a symbol
    can_edit = user.has_permission?('journey_patterns.edit')
    record.is_a?(Symbol) ? can_edit : (organisation_match?(via_referential: true) && can_edit)
  end

  def destroy?
    can_destroy = user.has_permission?('journey_patterns.destroy')
    record.is_a?(Symbol) ? can_destroy : (organisation_match?(via_referential: true) && can_destroy)
  end

  def update?  ; edit? end
  def new?     ; create? end
end

