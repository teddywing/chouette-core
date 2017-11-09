RSpec.describe ComplianceCheckBlock, type: :model do

  it { should belong_to :compliance_check_set }
  it { should have_many :compliance_checks }

  it { should allow_values(*%w{bus metro rail tram funicular}).for(:transport_mode) }
  it { should_not allow_values(*%w{bs mtro ril tramm Funicular}).for(:transport_mode) }


  it { should allow_values( *%w{ demandAndResponseBus nightBus airportLinkBus highFrequencyBus expressBus
                                 railShuttle suburbanRailway regionalRail interregionalRail })
        .for(:transport_submode) }

  it { should_not allow_values( *%w{ demandResponseBus nightus irportLinkBus highrequencyBus expressBUs
                                     Shuttle suburban regioalRail interregion4lRail })
        .for(:transport_submode) }
end
