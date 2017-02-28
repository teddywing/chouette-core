var React = require('react')
var PropTypes = require('react').PropTypes
var AddVehicleJourney = require('../containers/tools/AddVehicleJourney')
var DeleteVehicleJourneys = require('../containers/tools/DeleteVehicleJourneys')
var ShiftVehicleJourney = require('../containers/tools/ShiftVehicleJourney')
var DuplicateVehicleJourney = require('../containers/tools/DuplicateVehicleJourney')
var EditVehicleJourney = require('../containers/tools/EditVehicleJourney')
var NotesEditVehicleJourney = require('../containers/tools/NotesEditVehicleJourney')
var CalendarsEditVehicleJourney = require('../containers/tools/CalendarsEditVehicleJourney')
var actions = require('../actions')

const Tools = ({vehicleJourneys, onCancelSelection}) => {
  return (
    <div>
      <h4>Sélectionner une ou plusieurs courses (en colonne)</h4>
      <div className='list-inline clearfix'>
        <AddVehicleJourney />
        <DuplicateVehicleJourney />
        <ShiftVehicleJourney />
        <EditVehicleJourney />
        <CalendarsEditVehicleJourney />
        <NotesEditVehicleJourney />
        <DeleteVehicleJourneys />
      </div>
      <div>
      <span>{actions.getSelected(vehicleJourneys).length} course(s) sélectionnée(s)</span>
      <br/>
      <button
        onClick={onCancelSelection}
      ><span className='fa fa-times'>Annuler la sélection</span></button>
      </div>
    </div>
  )
}

Tools.propTypes = {
  vehicleJourneys : PropTypes.array.isRequired,
  onCancelSelection: PropTypes.func.isRequired
}

module.exports = Tools
