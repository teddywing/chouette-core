class TimeTablePolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    !archived? && user.has_permission?('time_tables.create') # organisation match via referential is checked in the view
  end

  def destroy?
    !archived? && organisation_match? && user.has_permission?('time_tables.destroy')
  end

  def update?
    !archived? && organisation_match? && user.has_permission?('time_tables.edit')
  end

  def actualize?
    !archived? && organisation_match? && edit?
  end

  def duplicate?
    !archived? && organisation_match? && create?
  end
end
