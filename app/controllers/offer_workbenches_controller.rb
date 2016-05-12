class OfferWorkbenchesController < BreadcrumbController

  defaults :resource_class => OfferWorkbench
  respond_to :html, :only => [:show]

  def show
    show! do
      build_breadcrumb :show
    end
  end

end
