var React = require('react')
var VehicleJourneysList = require('../containers/vehicleJourneysList')
var Navigate = require('../containers/Navigate')
var FiltersList = require('../containers/FiltersList')

const App = () => (
  <div>
    <div className='clearfix' style={{ marginBottom: 10 }}>
      <FiltersList />
      <Navigate />
    </div>
    <VehicleJourneysList />
  </div>
)

module.exports = App
