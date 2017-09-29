module StifTransportModeEnumerations
  extend ActiveSupport::Concern
  extend Enumerize

  enumerize :transport_mode, in: %w(air bus coach ferry metro rail trolleyBus tram water cableway funicular other)

  def transport_modes
    StifTransportModeEnumerations.transport_mode.options.map(&:first)
  end
end
