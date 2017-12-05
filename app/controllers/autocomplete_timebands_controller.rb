class AutocompleteTimebandsController < ChouetteController
  respond_to :json, :only => [:index]

  include ReferentialSupport

  protected

  def select_timebands
    if params[:route_id]
      referential.timebands.joins( vehicle_journeys: :route).where( "routes.id IN (#{params[:route_id]})")
    else
      referential.timebands
    end
  end

  def referential_timebands
    @referential_timebands ||= select_timebands
  end

  def collection
    @timebands = referential_timebands.select{ |p| p.fullname =~ /#{params[:q]}/i  }
  end
end
