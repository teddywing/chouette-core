class ComplianceControlPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def destroy?
    user.has_permission?('compliance_controls.destroy')
  end

  def create?
    user.has_permission?('compliance_controls.create')
  end

  def update?
    user.has_permission?('compliance_controls.update')
  end

end
