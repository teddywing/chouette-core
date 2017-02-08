var React = require('react')
var PropTypes = require('react').PropTypes

const VehicleJourney = (props) => {
  return (
    <div className={'list-group-item'}>

      <div style={{display: 'inline-block', verticalAlign: 'top', width: 'calc(100% - 25px)'}}>
        {/* Name */}
        <p className='small'>
          <strong>Id: </strong>{props.value.journey_pattern_id}
        </p>

        {/* Published name */}
        <p className='small'>
          <strong>Objectid: </strong>{props.value.objectid}
        </p>

        {/* Registration number */}
        <p className='small'>
          <strong>Registration number: </strong>{props.value.registration_number}
        </p>

      </div>

    </div>
  )
}

VehicleJourney.propTypes = {
  value: PropTypes.object,
  index: PropTypes.number,
}

module.exports = VehicleJourney
