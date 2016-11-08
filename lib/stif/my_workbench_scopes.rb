class Stif::MyWorkbenchScopes
  attr_accessor :organisation

  def initialize(workbench)
    @workbench = workbench
  end

  def line_scope
    scope = Chouette::Line
    ids   = self.parse_functional_scope
    ids ? scope.where(objectid: ids) : scope.all
  end

  def parse_functional_scope
    return false unless @workbench.organisation.sso_attributes
    begin
      line_ids = JSON.parse @workbench.organisation.sso_attributes['functional_scope']
    rescue Exception => e
      Rails.logger.error "MyWorkbenchScopes : #{e}"
    end
  end
end
