class VehicleJourneyPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    !referential_read_only? && organisation_match? && user.has_permission?('vehicle_journeys.create')
  end

  def destroy?
    !referential_read_only? && organisation_match? && user.has_permission?('vehicle_journeys.destroy')
  end

  def update?
    !referential_read_only? && organisation_match? && user.has_permission?('vehicle_journeys.update')
  end
end
