module StifTransportModeEnumerations
  extend ActiveSupport::Concern

  class << self
    def transport_modes
      %w(bus metro rail tram funicular)
    end
    def sorted_transport_modes
      transport_modes.sort_by{|m| I18n.t("enumerize.transport_mode.#{m}").parameterize }
    end
  end
  
  included do
    extend Enumerize
    enumerize :transport_mode, in: StifTransportModeEnumerations.transport_modes
  end

end
