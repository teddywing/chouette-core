var React = require('react')
var PropTypes = require('react').PropTypes
var actions = require('../../actions')

const DeleteVehicleJourneys = ({onDeleteVehicleJourneys, vehicleJourneys, filters}) => {
  return (
    <div  className='pull-left'>
      <button
        disabled= {(actions.getSelected(vehicleJourneys).length > 0 && filters.policy['vehicle_journeys.destroy']) ? false : true}
        type='button'
        className='btn btn-primary btn-sm'
        onClick={onDeleteVehicleJourneys}
        >
        <span className='fa fa-trash'></span>
        </button>
    </div>
  )
}

DeleteVehicleJourneys.propTypes = {
  onDeleteVehicleJourneys: PropTypes.func.isRequired,
  vehicleJourneys: PropTypes.array.isRequired,
  filters: PropTypes.object.isRequired
}

module.exports = DeleteVehicleJourneys
