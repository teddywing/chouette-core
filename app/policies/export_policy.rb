class ExportPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    user.has_permission?('exports.create')
  end

  def update?
    user.has_permission?('exports.update')
  end
end
