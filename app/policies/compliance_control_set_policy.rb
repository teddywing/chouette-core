class ComplianceControlSetPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def destroy?
    user.has_permission?('compliance_controls_sets.destroy')
  end

  def create?
    user.has_permission?('compliance_controls_sets.create')
  end

  def update?
    user.has_permission?('compliance_controls_sets.update')
  end

  def clone?
    create?
  end
end
