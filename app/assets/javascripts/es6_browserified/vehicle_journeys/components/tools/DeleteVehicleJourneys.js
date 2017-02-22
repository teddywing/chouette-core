var React = require('react')
var PropTypes = require('react').PropTypes
var actions = require('../../actions')

const DeleteVehicleJourneys = ({onDeleteVehicleJourneys, vehicleJourneys}) => {
  return (
    <div  className='pull-left'>
      <button
        disabled= {(actions.countSelected(vehicleJourneys) > 0) ? false : true}
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
  vehicleJourneys: PropTypes.array.isRequired
}

module.exports = DeleteVehicleJourneys
