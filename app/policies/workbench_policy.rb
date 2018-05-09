class WorkbenchPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def update?
    user.has_permission?('workbenches.update')
  end
end
