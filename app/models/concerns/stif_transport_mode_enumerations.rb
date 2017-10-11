module StifTransportModeEnumerations
  extend ActiveSupport::Concern
  extend Enumerize
  extend self

  enumerize :transport_mode, in: %w(bus
                                    metro
                                    rail
                                    tram)

  def transport_modes
    StifTransportModeEnumerations.transport_mode.values
  end

  def sorted_transport_modes
    self.transport_modes.sort_by{|m| I18n.t("enumerize.transport_mode.#{m}").parameterize }
  end
end
