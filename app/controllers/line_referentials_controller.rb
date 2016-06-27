class LineReferentialsController < BreadcrumbController

  defaults :resource_class => LineReferential

  protected

  def begin_of_chain
    current_organisation
  end

  def line_referential_params
    params.require(:line_referential).permit(:sync_interval)
  end

end
