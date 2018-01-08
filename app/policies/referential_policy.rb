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
    !archived_or_finalised? && organisation_match? && user.has_permission?('referentials.destroy')
  end

  def update?
    !archived_or_finalised? && organisation_match? && user.has_permission?('referentials.update')
  end

  def clone?
    !archived_or_finalised? && create?
  end

  def validate?
    !archived_or_finalised? && create? && organisation_match?
  end

  def archive?
    record.archived_at.nil? && organisation_match? && user.has_permission?('referentials.update')
  end

  def unarchive?
    !record.archived_at.nil? && organisation_match? && user.has_permission?('referentials.update')
  end

  def common_lines?
    # TODO: Replace with correct BL ASA available, c.f. https://projects.af83.io/issues/2692
    true
  end

end
