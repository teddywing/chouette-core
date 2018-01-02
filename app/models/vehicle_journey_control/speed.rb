module VehicleJourneyControl
  class Speed < ComplianceControl
    store_accessor :control_attributes, :minimum, :maximum

    validates_numericality_of :minimum, allow_nil: true, greater_than_or_equal_to: 0
    validates_numericality_of :maximum, allow_nil: true, greater_than_or_equal_to: 0
    include MinMaxValuesValidation

    def self.default_code; "3-VehicleJourney-2" end
  end
end
