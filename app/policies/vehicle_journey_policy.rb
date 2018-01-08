class VehicleJourneyPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    !archived_or_finalised? && organisation_match? && user.has_permission?('vehicle_journeys.create')
  end

  def destroy?
    !archived_or_finalised? && organisation_match? && user.has_permission?('vehicle_journeys.destroy')
  end

  def update?
    !archived_or_finalised? && organisation_match? && user.has_permission?('vehicle_journeys.update')
  end
end
