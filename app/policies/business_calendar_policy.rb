class BusinessCalendarPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create? 
    user.has_permission?('business_calendars.create')
  end

  def destroy?
    organisation_match? && user.has_permission?('business_calendars.destroy')
  end

  def update?
    organisation_match? && user.has_permission?('business_calendars.update')
  end

end