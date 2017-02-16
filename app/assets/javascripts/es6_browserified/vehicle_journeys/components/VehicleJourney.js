var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes

class VehicleJourney extends Component {
  constructor(props) {
    super(props)
  }

  render() {
    return (
      <div className={'list-group-item'}>

        <div style={{display: 'inline-block', verticalAlign: 'top', width: 'calc(100% - 25px)'}}>
          {/* Name */}
          <p className='small'>
            <strong>Id: </strong>{this.props.value.journey_pattern_id}
          </p>

          {/* Published name */}
          <p className='small'>
            <strong>Objectid: </strong>{this.props.value.objectid}
          </p>

          {/* Registration number */}
          <p className='small'>
            <strong>Registration number: </strong>{this.props.value.registration_number}
          </p>

          <p className='small'>
            <strong>Calendars: </strong>
            {this.props.value.time_tables.map((tt, i)=>
              <span key = {i}>{tt.objectid}</span>
            )}
          </p>

          <ul className='list-group'>
            {this.props.value.vehicle_journey_at_stops.map((vj, i) =>
              <li
                key={i}
              >
                {this.props.filters.toggleArrivals &&
                  <span>
                    <input
                      type='number'
                      min='00'
                      max='23'
                      onChange={(e) => {this.props.onUpdateTime(e, i, this.props.index, 'hour', false, false)}}
                      value={vj.arrival_time['hour']}
                    />
                    <span>:</span>
                    <input
                      type='number'
                      min='00'
                      max='59'
                      onChange={(e) => {this.props.onUpdateTime(e, i, this.props.index, 'minute', false, false)}}
                      value={vj.arrival_time['minute']}
                    />
                  </span>
                }
                <span>
                  <input
                    type='number'
                    min='00'
                    max='23'
                    onChange={(e) => {this.props.onUpdateTime(e, i, this.props.index, 'hour', true, this.props.filters.toggleArrivals)}}
                    value={vj.departure_time['hour']}
                  />
                  <span>:</span>
                  <input
                    type='number'
                    min='00'
                    max='59'
                    onChange={(e) => {this.props.onUpdateTime(e, i, this.props.index, "minute", true,  this.props.filters.toggleArrivals)}}
                    value={vj.departure_time['minute']}
                  />
                </span>
              </li>
            )}
          </ul>
        </div>

      </div>
    )
  }
}

VehicleJourney.propTypes = {
  value: PropTypes.object.isRequired,
  filters: PropTypes.object.isRequired,
  index: PropTypes.number.isRequired,
  onUpdateTime: PropTypes.func.isRequired,
}

module.exports = VehicleJourney
