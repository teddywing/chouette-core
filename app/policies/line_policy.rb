class LinePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    false
  end
  def update?  ; false end
  def new?     ; create? end
  def edit?    ; false end
  def destroy? ; create? end
  def update_footnote?; true end
end
