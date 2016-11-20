class LinePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    false
  end
  def update?  ; true end
  def new?     ; create? end
  def edit?    ; true end
  def destroy? ; create? end
end
