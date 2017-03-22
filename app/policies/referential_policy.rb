class ReferentialPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    true
  end

  def edit?
    organisation_match?
  end

  def update?
    edit? && !record.archived?
  end

  def archive?
    edit?
  end

  def unarchive? ; archive? end
  def new?       ; create? end
  def destroy?   ; edit? end
end


