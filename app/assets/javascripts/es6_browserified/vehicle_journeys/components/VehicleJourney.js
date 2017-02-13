var React = require('react')
var PropTypes = require('react').PropTypes

const VehicleJourney = ({value, filters}) => {
  return (
    <div className={'list-group-item'}>

      <div style={{display: 'inline-block', verticalAlign: 'top', width: 'calc(100% - 25px)'}}>
        {/* Name */}
        <p className='small'>
          <strong>Id: </strong>{value.journey_pattern_id}
        </p>

        {/* Published name */}
        <p className='small'>
          <strong>Objectid: </strong>{value.objectid}
        </p>

        {/* Registration number */}
        <p className='small'>
          <strong>Registration number: </strong>{value.registration_number}
        </p>
        <ul className='list-group'>
          {value.vehicle_journey_at_stops.map((vj, i) =>
            <li
              key={i}
            >
              <input type='text' defaultValue={vj.arrival_time}/>
              <span></span>
              {filters.toggleArrivals &&
                <input type='text' defaultValue={vj.departure_time}/>
              }
            </li>
          )}
        </ul>
      </div>

    </div>
  )
}

VehicleJourney.propTypes = {
  value: PropTypes.object.isRequired,
  filters: PropTypes.object.isRequired
}

module.exports = VehicleJourney
