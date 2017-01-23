class FootnotePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    user.has_permission?('footnotes.create')
  end

  def edit?
    user.has_permission?('footnotes.edit')
  end

  def destroy?
    user.has_permission?('footnotes.destroy')
  end

  def update?  ; edit? end
  def new?     ; create? end
end
