class StopAreaReferentialsController < BreadcrumbController

  defaults :resource_class => StopAreaReferential

  protected

  def begin_of_chain
    current_organisation
  end

end
