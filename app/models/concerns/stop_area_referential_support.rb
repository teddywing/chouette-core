module StopAreaReferentialSupport
  extend ActiveSupport::Concern

  included do
    belongs_to :stop_area_referential
    # validates_presence_of :stop_area_referential_id

    alias_method :referential, :stop_area_referential
  end

  def hub_restricted?
    false
  end

  def prefix
    # FIXME #825
    "dummy"
  end
end
