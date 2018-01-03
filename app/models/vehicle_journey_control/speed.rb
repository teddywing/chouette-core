module VehicleJourneyControl
  class Speed < ComplianceControl
    store_accessor :control_attributes, :minimum, :maximum

    validates :minimum, numericality: true, allow_nil: true
    validates :maximum, numericality: true, allow_nil: true
    include MinMaxValuesValidation

    def self.default_code; "3-VehicleJourney-2" end
  end
end
