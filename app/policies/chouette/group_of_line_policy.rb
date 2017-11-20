class Chouette::GroupOfLinePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end
end
