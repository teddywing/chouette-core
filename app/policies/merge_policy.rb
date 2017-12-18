class MergePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    user.has_permission?('merges.create')
  end

  def update?
    user.has_permission?('merges.update')
  end
end
