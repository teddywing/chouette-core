class CalendarPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def show?
    organisation_match? || record.shared
  end

  def new?     ; modify?  end
  def create?  ; new? end

  def edit?    ; modify? end
  def update?  ; edit? end

  def destroy? ; modify? end

  def share?
    user.organisation.name == 'STIF' # FIXME
  end

  def modify?
    organisation_match?
  end
end
