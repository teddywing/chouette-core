class VehicleJourneyPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    user.has_permission?('vehicle_journeys.create')
  end

  def edit?
    user.has_permission?('vehicle_journeys.edit')
  end

  def destroy?
    user.has_permission?('vehicle_journeys.destroy')
  end

  def update?  ; edit? end
  def new?     ; create? end
end
