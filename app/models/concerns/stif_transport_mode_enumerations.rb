module StifTransportModeEnumerations
  extend ActiveSupport::Concern
  
  included do
    extend Enumerize
    enumerize :transport_mode, in: StifTransportModeEnumerations.transport_modes
  end

  module ClassMethods
    def transport_modes; StifTransportModeEnumerations.transport_modes end
    def sorted_transport_modes; StifTransportModeEnumerations.sorted_transport_modes end
  end

  class << self
    def transport_modes
      %w(bus metro rail tram funicular)
    end
    def sorted_transport_modes
      transport_modes.sort_by{|m| I18n.t("enumerize.transport_mode.#{m}").parameterize }
    end
  end

end
