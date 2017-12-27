import React, { PropTypes, Component } from 'react'
import actions from '../actions'

export default class VehicleJourney extends Component {
  constructor(props) {
    super(props)
    this.previousCity = undefined
  }

  cityNameChecker(sp) {
    let bool = false
    if(sp.stop_area_cityname != this.previousCity){
      bool = true
      this.previousCity = sp.stop_area_cityname
    }

    return bool
  }

  timeTableURL(tt) {
    let refURL = window.location.pathname.split('/', 3).join('/')
    let ttURL = refURL + '/time_tables/' + tt.id

    return (
      <a href={ttURL} title='Voir le calendrier'><span className='fa fa-calendar' style={{ color: (tt.color ? tt.color : '#4B4B4B')}}></span></a>
    )
  }

  columnHasDelta() {
    let a = []
    this.props.value.vehicle_journey_at_stops.map((vj, i) => {
      a.push(vj.delta)
    })
    let b = a.reduce((p, c) => p+c, 0)

    if(b > 0) {
      return true
    }
  }

  isDisabled(bool1, bool2) {
    return (bool1 || bool2)
  }

  render() {
    this.previousCity = undefined
    let {time_tables} = this.props.value

    return (
      <div className={'t2e-item' + (this.props.value.deletable ? ' disabled' : '') + (this.props.value.errors ? ' has-error': '')}>
        <div className='th'>
          <div className='strong mb-xs'>{this.props.value.short_id || '-'}</div>
          <div>{this.props.value.journey_pattern.short_id || '-'}</div>
          <div>
            {time_tables.slice(0,3).map((tt, i)=>
              <span key={i} className='vj_tt'>{this.timeTableURL(tt)}</span>
            )}
            {time_tables.length > 3 && <span className='vj_tt'> + {time_tables.length - 3}</span>}
          </div>
          <div className={(this.props.value.deletable ? 'disabled ' : '') + 'checkbox'}>
            <input
              id={this.props.index}
              name={this.props.index}
              style={{display: 'none'}}
              onChange={(e) => this.props.onSelectVehicleJourney(this.props.index)}
              type='checkbox'
              disabled={this.props.value.deletable}
              checked={this.props.value.selected}
            ></input>
            <label htmlFor={this.props.index}></label>
          </div>
        </div>
        {this.props.value.vehicle_journey_at_stops.map((vj, i) =>
          <div key={i} className='td text-center'>
            <div className={'cellwrap' + (this.cityNameChecker(vj) ? ' headlined' : '')}>
              {this.props.filters.toggleArrivals &&
                <div data-headline='Arrivée à'>
                  <span className={((this.isDisabled(this.props.value.deletable, vj.dummy) || this.props.filters.policy['vehicle_journeys.update'] == false) ? 'disabled ' : '') + 'input-group time'}>
                    <input
                      type='number'
                      min='00'
                      max='23'
                      className='form-control'
                      disabled={this.isDisabled(this.props.value.deletable, vj.dummy) || this.props.filters.policy['vehicle_journeys.update'] == false}
                      readOnly={!this.props.editMode && !vj.dummy}
                      disabled={!this.props.editMode && !vj.dummy}
                      onChange={(e) => {this.props.onUpdateTime(e, i, this.props.index, 'hour', false, false)}}
                      value={vj.arrival_time['hour']}
                      />
                    <span>:</span>
                    <input
                      type='number'
                      min='00'
                      max='59'
                      className='form-control'
                      disabled={this.isDisabled(this.props.value.deletable, vj.dummy) || this.props.filters.policy['vehicle_journeys.update'] == false}
                      readOnly={!this.props.editMode && !vj.dummy}
                      disabled={!this.props.editMode && !vj.dummy}
                      onChange={(e) => {this.props.onUpdateTime(e, i, this.props.index, 'minute', false, false)}}
                      value={vj.arrival_time['minute']}
                      />
                  </span>
                </div>
                }
                <div className={(this.columnHasDelta() ? '' : 'hidden')}>
                  {(vj.delta != 0) &&
                    <span className='sb sb-chrono sb-lg text-warning' data-textinside={vj.delta}></span>
                  }
                </div>
                <div data-headline='Départ à'>
                  <span className={((this.isDisabled(this.props.value.deletable, vj.dummy) || this.props.filters.policy['vehicle_journeys.update'] == false) ? 'disabled ' : '') + 'input-group time'}>
                    <input
                      type='number'
                      min='00'
                      max='23'
                      className='form-control'
                      disabled={this.isDisabled(this.props.value.deletable, vj.dummy) || this.props.filters.policy['vehicle_journeys.update'] == false}
                      readOnly={!this.props.editMode && !vj.dummy}
                      disabled={!this.props.editMode && !vj.dummy}
                      onChange={(e) => {this.props.onUpdateTime(e, i, this.props.index, 'hour', true, this.props.filters.toggleArrivals)}}
                      value={vj.departure_time['hour']}
                      />
                    <span>:</span>
                    <input
                      type='number'
                      min='00'
                      max='59'
                      className='form-control'
                      disabled={this.isDisabled(this.props.value.deletable, vj.dummy) || this.props.filters.policy['vehicle_journeys.update'] == false}
                      readOnly={!this.props.editMode && !vj.dummy}
                      disabled={!this.props.editMode && !vj.dummy}
                      onChange={(e) => {this.props.onUpdateTime(e, i, this.props.index, "minute", true,  this.props.filters.toggleArrivals)}}
                      value={vj.departure_time['minute']}
                      />
                  </span>
                </div>
            </div>
          </div>
        )}
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
