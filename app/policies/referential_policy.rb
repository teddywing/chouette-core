class ReferentialPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    user.has_permission?('referentials.create')
  end

  def edit?
    user.has_permission?('referentials.edit')
  end

  def destroy?
    user.has_permission?('referentials.destroy')
  end

  def archive?
    edit?
  end

  def unarchive? ; archive? end
  def update? ; edit? end
  def new? ; create? end
  def clone? ; create? end
end




