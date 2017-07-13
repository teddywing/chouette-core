class TimeTablePolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    !archived? && organisation_match? && user.has_permission?('time_tables.create')
  end

  def destroy?
    !archived? && organisation_match? && user.has_permission?('time_tables.destroy')
  end

  def update?
    !archived? && organisation_match? && user.has_permission?('time_tables.update')
  end

  def actualize?
    !archived? && organisation_match? && edit?
  end

  def duplicate?
    !archived? && organisation_match? && create?
  end

  def month?
    update?
  end
end
