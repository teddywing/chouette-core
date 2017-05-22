class TimeTablePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    user.has_permission?('time_tables.create') # organisation match via referential is checked in the view
  end

  def edit?
    organisation_match? && user.has_permission?('time_tables.edit')
  end

  def destroy?
    organisation_match? && user.has_permission?('time_tables.destroy')
  end

  def duplicate?
    organisation_match? && create?
  end

  def update?  ; edit? end
  def new?     ; create? end
end
