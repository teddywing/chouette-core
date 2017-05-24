require_relative 'chain'
class LinePolicy < BoivPolicy
  extend Policies::Chain

  chain_policies :archived?, :!, policies: %i{create_footnote? destroy_footnote? edit_footnote?}

  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    false
  end
  def update?  ; false end
  def new?     ; create? end
  def edit?    ; false end
  def destroy? ; create? end

  def create_footnote?
    user.has_permission?('footnotes.create')
  end

  def edit_footnote?
    user.has_permission?('footnotes.edit')
  end

  def destroy_footnote?
    user.has_permission?('routes.destroy')
  end

  def update_footnote?  ; edit_footnote? end
  def new_footnote?     ; create_footnote? end
end
