class ReferentialPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    user.has_permission?('referentials.create')
  end

  def destroy?
    !archived? && organisation_match? && user.has_permission?('referentials.destroy')
  end

  def update?
    !archived? && organisation_match? && user.has_permission?('referentials.edit')
  end



  def clone?
    !archived? && organisation_match? && create?
  end

  def archive?
    !archived? && update?
  end

  def unarchive?
    archived? && update?
  end

  def common_lines?
    # TODO: Replace with correct BL ASA available, c.f. https://projects.af83.io/issues/2692
    true
  end

end




