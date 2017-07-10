class CalendarPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create? 
    !archived? && user.has_permission?('calendars.create')
  end
  def destroy?
    !archived? & organisation_match? && user.has_permission?('calendars.destroy')
  end
  def update?
    !archived? && organisation_match? && user.has_permission?('calendars.update')
  end

  def share?
    user.organisation.name == 'STIF' # FIXME
  end

end
