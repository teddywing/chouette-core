class ComplianceControlSetPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def show?
    organisation_match? or belongs_to_stif?
  end

  def destroy?
    user.has_permission?('compliance_control_sets.destroy')
  end

  def create?
    user.has_permission?('compliance_control_sets.create')
  end

  def update?
    user.has_permission?('compliance_control_sets.update')
  end

  def clone?
    create?
  end
end
