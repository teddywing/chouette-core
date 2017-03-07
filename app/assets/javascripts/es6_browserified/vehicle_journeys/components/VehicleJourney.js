var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes

class VehicleJourney extends Component {
  constructor(props) {
    super(props)
  }

  render() {
    return (
      <div className={'t2e-item' + (this.props.value.deletable ? ' disabled' : '')} >

        <div className='th'>
          <div className='strong mb-xs'>{this.props.value.objectid ? this.props.value.objectid : '-'}</div>
          <div>{this.props.value.journey_pattern.objectid}</div>
          <div>
            {this.props.value.time_tables.map((tt, i)=>
              <span key={i}>{tt.objectid}</span>
            )}
          </div>

          <div
            className={(this.props.value.deletable ? 'disabled ' : '') + 'checkbox'}
          >
            <input
              id={this.props.index}
              name={this.props.index}
              onChange={(e) => this.props.onSelectVehicleJourney(this.props.index)}
              type='checkbox'
              disabled={this.props.value.deletable}
              checked={this.props.value.selected}
            ></input>
          <label htmlFor={this.props.index}></label>
          </div>
        </div>

        <div style={{display: 'inline-block', verticalAlign: 'top', width: 'calc(100% - 25px)'}}>
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
                      disabled = {this.props.value.deletable}
                      onChange={(e) => {this.props.onUpdateTime(e, i, this.props.index, 'hour', false, false)}}
                      value={vj.arrival_time['hour']}
                    />
                    <span>:</span>
                    <input
                      type='number'
                      min='00'
                      max='59'
                      disabled = {this.props.value.deletable}
                      onChange={(e) => {this.props.onUpdateTime(e, i, this.props.index, 'minute', false, false)}}
                      value={vj.arrival_time['minute']}
                    />
                  </span>
                }
                {(vj.delta != 0) &&
                  <span>Delta: {vj.delta}</span>
                }
                <span>
                  <input
                    type='number'
                    min='00'
                    max='23'
                    disabled = {this.props.value.deletable}
                    onChange={(e) => {this.props.onUpdateTime(e, i, this.props.index, 'hour', true, this.props.filters.toggleArrivals)}}
                    value={vj.departure_time['hour']}
                  />
                  <span>:</span>
                  <input
                    type='number'
                    min='00'
                    max='59'
                    disabled = {this.props.value.deletable}
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
  onSelectVehicleJourney: PropTypes.func.isRequired
}

module.exports = VehicleJourney
