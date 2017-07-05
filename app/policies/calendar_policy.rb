class CalendarPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create? 
    !archived? && organisation_match?
  end
  def destroy?
    !archived? && organisation_match?
  end
  def update?
    !archived? && organisation_match?
  end

  def share?
    user.organisation.name == 'STIF' # FIXME
  end

end
