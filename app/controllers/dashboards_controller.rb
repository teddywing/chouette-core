class DashboardsController < BreadcrumbController
  respond_to :html, only: [:show]

  def show
    @dashboard = Dashboard.create self
  end

end
