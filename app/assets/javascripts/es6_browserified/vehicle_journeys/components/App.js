var React = require('react')
var VehicleJourneysList = require('../containers/vehicleJourneysList')
var Navigate = require('../containers/Navigate')
var FiltersList = require('../containers/FiltersList')
var SaveVehicleJourneys = require('../containers/SaveVehicleJourneys')
var ConfirmModal = require('../containers/ConfirmModal')
var AddVehicleJourney = require('../containers/tools/AddVehicleJourney')
var DeleteVehicleJourneys = require('../containers/tools/DeleteVehicleJourneys')
var ShiftVehicleJourney = require('../containers/tools/ShiftVehicleJourney')
var DuplicateVehicleJourney = require('../containers/tools/DuplicateVehicleJourney')
var EditVehicleJourney = require('../containers/tools/EditVehicleJourney')
var NotesEditVehicleJourney = require('../containers/tools/NotesEditVehicleJourney')
var CalendarsEditVehicleJourney = require('../containers/tools/CalendarsEditVehicleJourney')

const App = () => (
  <div>
    <div className='clearfix' style={{ marginBottom: 10 }}>
      <FiltersList />
      <Navigate />
      <div className='list-inline clearfix'>
        <AddVehicleJourney />
        <DeleteVehicleJourneys />
        <ShiftVehicleJourney />
        <DuplicateVehicleJourney />
        <EditVehicleJourney />
        <NotesEditVehicleJourney />
        <CalendarsEditVehicleJourney />
      </div>
    </div>
    <VehicleJourneysList />
    <SaveVehicleJourneys />
    <ConfirmModal />
  </div>
)

module.exports = App
