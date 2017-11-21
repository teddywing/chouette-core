module Chouette
  class GroupOfLinePolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        scope
      end
    end
  end
end