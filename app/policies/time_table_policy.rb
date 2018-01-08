class TimeTablePolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    !archived_or_finalised? && organisation_match? && user.has_permission?('time_tables.create')
  end

  def destroy?
    !archived_or_finalised? && organisation_match? && user.has_permission?('time_tables.destroy')
  end

  def update?
    !archived_or_finalised? && organisation_match? && user.has_permission?('time_tables.update')
  end

  def actualize?
    !archived_or_finalised? && organisation_match? && edit?
  end

  def duplicate?
    !archived_or_finalised? && organisation_match? && create?
  end

  def month?
    update?
  end
end
