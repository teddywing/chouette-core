import React, { PropTypes } from 'react'
import actions from '../../actions'

export default function DeleteVehicleJourneys({onDeleteVehicleJourneys, vehicleJourneys, filters}) {
  return (
    <li className='st_action'>
      <button
        type='button'
        disabled={(actions.getSelected(vehicleJourneys).length > 0 && filters.policy['vehicle_journeys.destroy']) ? '' : 'disabled'}
        onClick={e => {
          e.preventDefault()
          onDeleteVehicleJourneys()
        }}
        title='Supprimer'
      >
        <span className='fa fa-trash'></span>
      </button>
    </li>
  )
}

DeleteVehicleJourneys.propTypes = {
  onDeleteVehicleJourneys: PropTypes.func.isRequired,
  vehicleJourneys: PropTypes.array.isRequired,
  filters: PropTypes.object.isRequired
}