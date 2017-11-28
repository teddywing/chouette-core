class ComplianceCheckSetPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end

      def create?
        false # ComplianceCheckSet can not be created from controller
      end

      def destroy?
        false # Asynchronous operations must not be deleted
      end

      def update?
        false # ComplianceCheckSet can not be updated from controller
      end
  end
end
