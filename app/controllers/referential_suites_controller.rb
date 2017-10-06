class ReferentialSuitesController < BreadcrumbController

  defaults resource_class: Workbench

  def index
    @workbench = Workbench.find(params[:workbench_id])
    @referentials = ModelDecorator.decorate(@workbench.output.try(:referentials) || [], with: ReferentialDecorator)
    index! do
      build_breadcrumb :index
    end

  end
end 
