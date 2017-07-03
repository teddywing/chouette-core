class LinePolicy < BoivPolicy

  class Scope < Scope
    def resolve
      scope
    end
  end

  def show?; true end
  def create?; false end
  def update?  ; false end
  def new?     ; create? end
  def edit?    ; false end
  def destroy? ; create? end

  def create_footnote?
    !archived? && user.has_permission?('footnotes.create')
  end

  def edit_footnote?
    !archived? && user.has_permission?('footnotes.edit')
  end

  def destroy_footnote?
    !archived? && user.has_permission?('footnotes.destroy')
  end

  def update_footnote?  ; edit_footnote? end
  def new_footnote?     ; create_footnote? end
end
