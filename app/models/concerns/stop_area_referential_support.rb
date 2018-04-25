module StopAreaReferentialSupport
  extend ActiveSupport::Concern

  included do
    belongs_to :stop_area_referential
    validates_presence_of :stop_area_referential
    alias_method :referential, :stop_area_referential
  end

  def workgroup
    stop_area_referential&.workgroup
  end

  def hub_restricted?
    false
  end
end
