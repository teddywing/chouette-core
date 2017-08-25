class TimeTableCombinationPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    !archived? && organisation_match? && user.has_permission?('time_tables.update')
  end
end
