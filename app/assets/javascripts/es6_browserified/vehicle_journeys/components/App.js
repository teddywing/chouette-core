var React = require('react')
var VehicleJourneysList = require('../containers/vehicleJourneysList')
var Navigate = require('../containers/Navigate')
var ToggleArrivals = require('../containers/ToggleArrivals')
var Filters = require('../containers/Filters')
var SaveVehicleJourneys = require('../containers/SaveVehicleJourneys')
var ConfirmModal = require('../containers/ConfirmModal')
var Tools = require('../containers/Tools')

const App = () => (
  <div>
    <div className='clearfix' style={{ marginBottom: 10 }}>
      <Filters />
      <ToggleArrivals />
      <Navigate />
      <Tools />
    </div>
    <VehicleJourneysList />
    <SaveVehicleJourneys />
    <ConfirmModal />
  </div>
)

module.exports = App
