module StopAreaReferentialSupport
  extend ActiveSupport::Concern

  included do
    belongs_to :stop_area_referential
    alias_method :referential, :stop_area_referential
  end

  def hub_restricted?
    false
  end
end
