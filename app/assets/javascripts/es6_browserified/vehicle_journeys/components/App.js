var React = require('react')
var VehicleJourneysList = require('../containers/vehicleJourneysList')
var Navigate = require('../containers/Navigate')

const App = () => (
  <div>
    <div className='clearfix' style={{ marginBottom: 10 }}>
      <Navigate />
    </div>
    <VehicleJourneysList />
  </div>
)

module.exports = App
