#
# If you changed the default Dashboard implementation (see Dashboard),
# this controller will use a custom partial like
# custom/dashboards/_dashboard.html.slim for Custom::Dashboard
#
class DashboardsController < ChouetteController
  respond_to :html, only: [:show]

  def show
    @dashboard = Dashboard.create self
  end

end
