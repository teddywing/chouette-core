class VehicleJourneyPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    user.has_permission?('vehicle_journeys.create') # organisation match via referential is checked in the view
  end

  def destroy?
    organisation_match? && user.has_permission?('vehicle_journeys.destroy')
  end

  def update?
    organisation_match? && user.has_permission?('vehicle_journeys.edit')
  end
end
