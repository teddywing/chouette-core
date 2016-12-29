class CalendarPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def show?
    organisation_match? || share?
  end

  def create?  ; true end
  def update?  ; true end
  def new?     ; true end
  def edit?    ; true end
  def destroy? ; true end

  def share?
    record.shared
  end

  def organisation_match?
    current_organisation == record.organisation
  end
end
