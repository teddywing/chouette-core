import React, { PropTypes, Component } from 'react'
import actions from '../actions'
import AddVehicleJourney from '../containers/tools/AddVehicleJourney'
import DeleteVehicleJourneys from '../containers/tools/DeleteVehicleJourneys'
import ShiftVehicleJourney from '../containers/tools/ShiftVehicleJourney'
import DuplicateVehicleJourney from '../containers/tools/DuplicateVehicleJourney'
import EditVehicleJourney from '../containers/tools/EditVehicleJourney'
import NotesEditVehicleJourney from '../containers/tools/NotesEditVehicleJourney'
import TimetablesEditVehicleJourney from '../containers/tools/TimetablesEditVehicleJourney'


export default class Tools extends Component {
  constructor(props) {
    super(props)
    this.hasPolicy = this.hasPolicy.bind(this)
  }

  hasPolicy(key) {
    // Check if the user has the policy to disable or not the action
    return this.props.filters.policy[`vehicle_journeys.${key}`]
  }

  render() {
    let { vehicleJourneys, onCancelSelection, editMode } = this.props
    return (
      <div className='select_toolbox'>
        <ul>
          <AddVehicleJourney disabled={this.hasPolicy("create") && !editMode} />
          <DuplicateVehicleJourney disabled={this.hasPolicy("create") && this.hasPolicy("update") && !editMode}/>
          <ShiftVehicleJourney disabled={this.hasPolicy("update") && !editMode}/>
          <EditVehicleJourney disabled={!this.hasPolicy("update")}/>
          <TimetablesEditVehicleJourney disabled={!this.hasPolicy("update")}/>
          <NotesEditVehicleJourney disabled={!this.hasPolicy("update")}/>
          <DeleteVehicleJourneys disabled={this.hasPolicy("destroy") && !editMode}/>
        </ul>

        <span className='info-msg'>{actions.getSelected(vehicleJourneys).length} course(s) sélectionnée(s)</span>
        <button className='btn btn-xs btn-link pull-right' onClick={onCancelSelection}>Annuler la sélection</button>
      </div>
    )
  }
}

Tools.propTypes = {
  vehicleJourneys : PropTypes.array.isRequired,
  onCancelSelection: PropTypes.func.isRequired,
  filters: PropTypes.object.isRequired
}
