class ReferentialSuitesController < BreadcrumbController

  defaults resource_class: ReferentialSuite

  def index
    @workbench = Workbench.find(params[:workbench_id])
    referentials = @workbench.output.try(:referentials) || Referential.none
    @q = referentials.search(params[:q])
    @referentials = ModelDecorator.decorate(referentials, with: ReferentialDecorator)
    index! do
      build_breadcrumb :index
    end

  end
end 
