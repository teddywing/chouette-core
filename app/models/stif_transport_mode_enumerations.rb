module StifTransportModeEnumerations
  extend Enumerize

  enumerize :transport_mode, in: %w(air bus coach ferry metro rail trolleyBus tram water cableway funicular other)
end
