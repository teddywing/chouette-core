var React = require('react')
var PropTypes = require('react').PropTypes
var AddVehicleJourney = require('../containers/tools/AddVehicleJourney')
var DeleteVehicleJourneys = require('../containers/tools/DeleteVehicleJourneys')
var ShiftVehicleJourney = require('../containers/tools/ShiftVehicleJourney')
var DuplicateVehicleJourney = require('../containers/tools/DuplicateVehicleJourney')
var EditVehicleJourney = require('../containers/tools/EditVehicleJourney')
var NotesEditVehicleJourney = require('../containers/tools/NotesEditVehicleJourney')
var TimetablesEditVehicleJourney = require('../containers/tools/TimetablesEditVehicleJourney')
var actions = require('../actions')

const Tools = ({vehicleJourneys, onCancelSelection}) => {
  return (
    <div className='select_toolbox'>
      <ul>
        <AddVehicleJourney />
        <DuplicateVehicleJourney />
        <ShiftVehicleJourney />
        <EditVehicleJourney />
        <TimetablesEditVehicleJourney />
        <NotesEditVehicleJourney />
        <DeleteVehicleJourneys />
      </ul>

      <span className='info-msg'>{actions.getSelected(vehicleJourneys).length} course(s) sélectionnée(s)</span>
      <button className='btn btn-xs btn-link pull-right' onClick={onCancelSelection}>Annuler la sélection</button>
    </div>
  )
}

Tools.propTypes = {
  vehicleJourneys : PropTypes.array.isRequired,
  onCancelSelection: PropTypes.func.isRequired
}

module.exports = Tools
