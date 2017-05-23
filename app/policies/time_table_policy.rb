class TimeTablePolicy < BoivPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    !archived? &&
      user.has_permission?('time_tables.create') # organisation match via referential is checked in the view
  end

  def edit?
    !archived? &&
      organisation_match? && user.has_permission?('time_tables.edit')
  end

  def destroy?
    !archived? &&
      organisation_match? && user.has_permission?('time_tables.destroy')
  end

  def duplicate?
    !archived? &&
      organisation_match? && create?
  end

  def update?  ; edit? end
  def new?     ; create? end
end
