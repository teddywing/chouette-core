class JourneyPatternPolicy < BoivPolicy

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
    organisation_match? && user.has_permission?('journey_patterns.edit')
  end

  def destroy?
    organisation_match? && user.has_permission?('journey_patterns.destroy')
  end

  def update?  ; edit? end
  def new?     ; create? end
end

