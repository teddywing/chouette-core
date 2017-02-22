var React = require('react')
var PropTypes = require('react').PropTypes

const DeleteVehicleJourneys = ({onDeleteVehicleJourneys}) => {
  return (
    <div  className='pull-left'>
      <button
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
  onDeleteVehicleJourneys: PropTypes.func.isRequired
}

module.exports = DeleteVehicleJourneys
