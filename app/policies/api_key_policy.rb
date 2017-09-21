class ApiKeyPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def destroy?
    organisation_match? && user.has_permission?('api_keys.destroy')
  end

  def create?
    user.has_permission?('api_keys.create')
  end

  def update?
    record.try(:organisation_id) == user.organisation_id &&
      user.has_permission?('api_keys.update')
  end
end
