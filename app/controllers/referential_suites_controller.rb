class ReferentialSuitesController < BreadcrumbController

  defaults resource_class: Workbench

  def index
    @workbench = Workbench.find(params[:workbench_id])
    @referentials = @workbench.output.try(:referentials) || []
    index! do
      build_breadcrumb :index
    end

  end
end 
