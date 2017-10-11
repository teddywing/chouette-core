module StifTransportSubmodeEnumerations
  extend ActiveSupport::Concern
  extend Enumerize
  extend self

  enumerize :transport_submode, in: %w(demandAndResponseBus
                                       nightBus
                                       airportLinkBus
                                       highFrequencyBus
                                       expressBus
                                       railShuttle
                                       suburbanRailway
                                       regionalRail
                                       interregionalRail
)

  def transport_submodes
    StifTransportSubmodeEnumerations.transport_submode.values
  end

  def sorted_transport_submodes
    self.transport_submodes.sort_by{|m| I18n.t("enumerize.transport_submode.#{m}").parameterize }
  end
end
