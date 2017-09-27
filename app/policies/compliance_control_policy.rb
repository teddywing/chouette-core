class ComplianceControlPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def destroy?
    # user.has_permission?('compliance_controls.destroy')
    true
  end

  def create?
    # user.has_permission?('compliance_controls.create')
    true
  end

  def update?
    # user.has_permission?('compliance_controls.update')
    true
  end
end
