var React = require('react')
var VehicleJourneysList = require('../containers/vehicleJourneysList')
var Navigate = require('../containers/Navigate')
var FiltersList = require('../containers/FiltersList')
var SaveVehicleJourneys = require('../containers/SaveVehicleJourneys')
var ConfirmModal = require('../containers/ConfirmModal')
var AddVehicleJourney = require('../containers/AddVehicleJourney')
var DeleteVehicleJourneys = require('../containers/DeleteVehicleJourneys')

const App = () => (
  <div>
    <div className='clearfix' style={{ marginBottom: 10 }}>
      <FiltersList />
      <Navigate />
      <AddVehicleJourney />
      <DeleteVehicleJourneys />
    </div>
    <VehicleJourneysList />
    <SaveVehicleJourneys />
    <ConfirmModal />
  </div>
)

module.exports = App
