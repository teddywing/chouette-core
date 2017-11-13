class ComplianceControlBlockPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def destroy?
    user.has_permission?('compliance_control_blocks.destroy')
  end

  def create?
    user.has_permission?('compliance_control_blocks.create')
  end

  def update?
    user.has_permission?('compliance_control_blocks.update')
  end

end
