class TimebandsController < ChouetteController

  defaults :resource_class => Chouette::Timeband

  respond_to :html

  belongs_to :referential

  private
  def timeband_params
    params.require(:timeband).permit( :name, :start_time, :end_time )
  end
end
