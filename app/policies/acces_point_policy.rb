class AccessPointPolicy < BoivPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    user.has_permission?('access_points.create') # organisation match via referential is checked in the view
  end

  def edit?
    organisation_match? && user.has_permission?('access_points.edit')
  end

  def destroy?
    organisation_match? && user.has_permission?('access_points.destroy')
  end

  def update?  ; edit? end
  def new?     ; create? end
end
