class PurchaseWindowPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
     !archived_or_finalised? && organisation_match? && user.has_permission?('purchase_windows.create')
  end

  def update?
    !archived_or_finalised? && organisation_match? && user.has_permission?('purchase_windows.update')
  end

  def destroy?
    !archived_or_finalised? && organisation_match? && user.has_permission?('purchase_windows.destroy')
  end

end
