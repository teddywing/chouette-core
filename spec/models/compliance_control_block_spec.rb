require 'rails_helper'

RSpec.describe ComplianceControlBlock, type: :model do

  it { should belong_to :compliance_control_set }
  it { should have_many(:compliance_controls).dependent(:destroy) }
  it { should validate_presence_of(:transport_mode) }

  it { should allow_values(*%w{bus metro rail tram funicular}).for(:transport_mode) }
  it { should_not allow_values(*%w{bs mtro ril tramm Funicular}).for(:transport_mode) }


  it { should allow_values( *%w{ demandAndResponseBus nightBus airportLinkBus highFrequencyBus expressBus
                                 railShuttle suburbanRailway regionalRail interregionalRail })
        .for(:transport_submode) }

  it { should_not allow_values( *%w{ demandResponseBus nightus irportLinkBus highrequencyBus expressBUs
                                     Shuttle suburban regioalRail interregion4lRail })
        .for(:transport_submode) }
end
