module ChouetteTransportModeEnumerations
  extend Enumerize

  enumerize :transport_mode, in: %w(interchange unknown coach air waterborne bus ferry walk
    metro shuttle rapid_transit taxi local_train train long_distance_train tramway trolleybus private_vehicle bicycle other)
end
