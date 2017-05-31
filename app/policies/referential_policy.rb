class ReferentialPolicy < BoivPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    user.has_permission?('referentials.create')
  end

  def edit?
    organisation_match? && user.has_permission?('referentials.edit')
  end

  def destroy?
    organisation_match? && user.has_permission?('referentials.destroy')
  end

  def archive?
    edit?
  end

  def clone?
    organisation_match? && create?
  end

  def common_lines?
    # TODO: Replace with correct BL ASA available, c.f. https://projects.af83.io/issues/2692
    true
  end

  def unarchive? ; archive? end
  def update? ; edit? end
  def new? ; create? end
end




