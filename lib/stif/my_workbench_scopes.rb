module Stif
  class MyWorkbenchScopes
    attr_accessor :workbench

    def initialize(workbench)
      @workbench = workbench
    end

    def line_scope(initial_scope)
      ids = self.parse_functional_scope
      ids ? initial_scope.where(objectid: ids) : initial_scope
    end

    def parse_functional_scope
      return false unless @workbench.organisation.sso_attributes
      begin
        JSON.parse @workbench.organisation.sso_attributes['functional_scope']
      rescue Exception => e
        Rails.logger.error "MyWorkbenchScopes : #{e}"
      end
    end
  end
end
