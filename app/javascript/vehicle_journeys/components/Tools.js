import React, { PropTypes } from 'react'
import actions from '../actions'
import AddVehicleJourney from '../containers/tools/AddVehicleJourney'
import DeleteVehicleJourneys from '../containers/tools/DeleteVehicleJourneys'
import ShiftVehicleJourney from '../containers/tools/ShiftVehicleJourney'
import DuplicateVehicleJourney from '../containers/tools/DuplicateVehicleJourney'
import EditVehicleJourney from '../containers/tools/EditVehicleJourney'
import NotesEditVehicleJourney from '../containers/tools/NotesEditVehicleJourney'
import TimetablesEditVehicleJourney from '../containers/tools/TimetablesEditVehicleJourney'

export default function Tools({vehicleJourneys, onCancelSelection, filters: {policy}, editMode}) {
  return (
    <div>
      {
        (policy['vehicle_journeys.create'] && policy['vehicle_journeys.update'] && policy['vehicle_journeys.destroy'] && editMode) &&
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
      }
    </div>
  )
}

Tools.propTypes = {
  vehicleJourneys : PropTypes.array.isRequired,
  onCancelSelection: PropTypes.func.isRequired,
  filters: PropTypes.object.isRequired
}