class CompanyPolicy < BoivPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?;   false end
  def destroy?;  false end
  def edit?;     false end
  def new?;      false end
  def show?;     true end
  def update?;   false end
end
