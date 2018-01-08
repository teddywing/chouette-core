class TimeTableCombinationPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    !archived_or_finalised? && organisation_match? && user.has_permission?('time_tables.update')
  end
end
