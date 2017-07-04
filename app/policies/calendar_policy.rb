class CalendarPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create? 
    organisation_match?
  end
  def destroy?
    organisation_match?
  end
  def update?
    organisation_match?
  end

  def share?
    user.organisation.name == 'STIF' # FIXME
  end

end
