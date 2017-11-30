class ImportPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    user.has_permission?('imports.create')
  end

  def update?
    user.has_permission?('imports.update')
  end
end
