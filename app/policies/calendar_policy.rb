class CalendarPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    !archived? && user.has_permission?('calendars.create')
  end
  def destroy?; instance_permission("destroy") end
  def update?; instance_permission("update") end
  def share?; instance_permission("share") end

  private
  def instance_permission permission
    !archived? & organisation_match? && user.has_permission?("calendars.#{permission}")
  end
end
