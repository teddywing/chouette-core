class ChouetteController < BreadcrumbController

  include ApplicationHelper
  include BreadcrumbHelper

  before_action :switch_referential

  def switch_referential
    Apartment::Tenant.switch!(referential.slug)
  end

  def referential
    @referential ||= Referential.find params[:referential_id]
  end

  alias_method :current_referential, :referential
  helper_method :current_referential

end
