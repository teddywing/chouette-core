class PurchaseWindowPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
     !archived? && organisation_match? && user.has_permission?('purchase_windows.create')
  end

  def update?
    !archived? && organisation_match? && user.has_permission?('purchase_windows.update')
  end

  def destroy?
    !archived? && organisation_match? && user.has_permission?('purchase_windows.destroy')
  end

end