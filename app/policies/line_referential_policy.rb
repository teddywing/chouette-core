class LineReferentialPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def synchronize?; instance_permission("synchronize") end

  private
  def instance_permission permission
    user.has_permission?("line_referentials.#{permission}")
  end
end
