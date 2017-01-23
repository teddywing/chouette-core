class TimeTablePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    user.has_permission?('time_tables.create')
  end

  def edit?
    user.has_permission?('time_tables.edit')
  end

  def destroy?
    user.has_permission?('time_tables.destroy')
  end

  def update?  ; edit? end
  def new?     ; create? end
end
