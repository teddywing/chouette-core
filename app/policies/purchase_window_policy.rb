class PurchaseWindowPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
     !referential_read_only? && organisation_match? && user.has_permission?('purchase_windows.create')
  end

  def update?
    !referential_read_only? && organisation_match? && user.has_permission?('purchase_windows.update')
  end

  def destroy?
    !referential_read_only? && organisation_match? && user.has_permission?('purchase_windows.destroy')
  end

end
