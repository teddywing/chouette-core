class TimeTablePolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    !referential_read_only? && organisation_match? && user.has_permission?('time_tables.create')
  end

  def destroy?
    !referential_read_only? && organisation_match? && user.has_permission?('time_tables.destroy')
  end

  def update?
    !referential_read_only? && organisation_match? && user.has_permission?('time_tables.update')
  end

  def actualize?
    !referential_read_only? && organisation_match? && edit?
  end

  def duplicate?
    !referential_read_only? && organisation_match? && create?
  end

  def month?
    update?
  end
end
