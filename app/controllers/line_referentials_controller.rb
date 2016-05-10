class LineReferentialsController < BreadcrumbController

  defaults :resource_class => LineReferential

  protected

  def begin_of_chain
    current_organisation
  end

end
