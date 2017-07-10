class VehicleJourneyPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    !archived? && organisation_match? && user.has_permission?('vehicle_journeys.create')
  end

  def destroy?
    !archived? && organisation_match? && user.has_permission?('vehicle_journeys.destroy')
  end

  def update?
    !archived? && organisation_match? && user.has_permission?('vehicle_journeys.update')
  end
end
