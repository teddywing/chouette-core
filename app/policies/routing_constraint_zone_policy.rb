class RoutingConstraintZonePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?  ; true end
  def update?  ; true end
  def new?     ; true end
  def edit?    ; true end
  def destroy? ; true end
end
