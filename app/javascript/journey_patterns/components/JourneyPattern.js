import React, { Component } from 'react'
import PropTypes from 'prop-types'
import actions from '../actions'

export default class JourneyPattern extends Component{
  constructor(props){
    super(props)
    this.previousSpId = undefined
    this.updateCosts = this.updateCosts.bind(this)
  }

  updateCosts(e) {
    let costs = {
      [e.target.dataset.costsKey]: {
        [e.target.name]: parseFloat(e.target.value)
      }
    }
    this.props.onUpdateJourneyPatternCosts(costs)
  }

  vehicleJourneyURL(jpOid) {
    let routeURL = window.location.pathname.split('/', 7).join('/')
    let vjURL = routeURL + '/vehicle_journeys?jp=' + jpOid

    return (
      <a href={vjURL}>{I18n.t('journey_patterns.journey_pattern.vehicle_journey_at_stops')}</a>
    )
  }

  hasFeature(key) {
    return this.props.status.features[key]
  }

  cityNameChecker(sp, i) {
    return this.props.journeyPatterns.showHeader((sp.stop_area_object_id || sp.object_id) + "-" + i)
  }

  spNode(sp, headlined){
    return (
      <div
        className={(headlined) ? 'headlined' : ''}
      >
        <div className={'link '}></div>
        <span className='has_radio'>
          <input
            onChange = {(e) => this.props.onCheckboxChange(e)}
            type='checkbox'
            id={sp.position}
            checked={sp.checked}
            disabled={(this.props.value.deletable || this.props.status.policy['journey_patterns.update'] == false || this.props.editMode == false) ? 'disabled' : ''}
            >
          </input>
          <span className='radio-label'></span>
        </span>
      </div>
    )
  }

  getErrors(errors) {
    let err = Object.keys(errors).map((key, index) => {
      return (
        <li key={index} style={{listStyleType: 'disc'}}>
          <strong>{key}</strong> { errors[key] }
        </li>
      )
    })

    return (
      <ul className="alert alert-danger">{err}</ul>
    )
  }

  isDisabled(action) {
    return !this.props.status.policy[`journey_patterns.${action}`]
  }

  totals(onlyCommercial=false){
    let totalTime = 0
    let totalDistance = 0
    let from = null
    this.props.value.stop_points.map((stopPoint, i) =>{
      let usePoint = stopPoint.checked
      if(onlyCommercial && (i == 0 || i == this.props.value.stop_points.length - 1) && stopPoint.kind == "non_commercial"){
        usePoint = false
      }
      if(from && usePoint){
        let [costsKey, costs, time, distance] = this.getTimeAndDistanceBetweenStops(from, stopPoint.id)
        totalTime += time
        totalDistance += distance
      }
      if(usePoint){
        from = stopPoint.id
      }
    })
    return [this.formatTime(totalTime), this.formatDistance(totalDistance)]
  }

  getTimeAndDistanceBetweenStops(from, to){
    let costsKey = from + "-" + to
    let costs = this.getCosts(costsKey)
    let time = costs['time'] || 0
    let distance = costs['distance'] || 0
    return [costsKey, costs, time, distance]
  }

  getCosts(costsKey) {
    let cost = this.props.value.costs[costsKey]

    if (cost) {
      return cost
    }

    this.props.fetchRouteCosts(costsKey)

    return { distance: 0, time: 0 }
  }

  formatDistance(distance){
    return parseFloat(Math.round(distance * 100) / 100).toFixed(2) + " km"
  }

  formatTime(time){
    if(time < 60){
      return time + " min"
    }
    else{
      let hours = parseInt(time/60)
      let minutes = (time - 60*hours)
      return hours + " h " + (minutes > 0 ? minutes : '')
    }
  }

  render() {
    this.previousSpId = undefined
    let [totalTime, totalDistance] = this.totals(false)
    let [commercialTotalTime, commercialTotalDistance] = this.totals(true)
    return (
      <div className={'t2e-item' + (this.props.value.deletable ? ' disabled' : '') + (this.props.value.object_id ? '' : ' to_record') + (this.props.value.errors ? ' has-error': '') + (this.hasFeature('costs_in_journey_patterns') ? ' with-costs' : '')}>
        <div className='th'>
          <div className='strong mb-xs'>{this.props.value.object_id ? this.props.value.short_id : '-'}</div>
          <div>{this.props.value.registration_number}</div>
          <div>{I18n.t('journey_patterns.show.stop_points_count', {count: actions.getChecked(this.props.value.stop_points).length})}</div>
          {this.hasFeature('costs_in_journey_patterns') &&
            <div className="small row totals">
              <span className="col-md-6"><i className="fa fa-arrows-h"></i>{totalDistance}</span>
              <span className="col-md-6"><i className="fa fa-clock-o"></i>{totalTime}</span>
            </div>
          }
          {this.hasFeature('costs_in_journey_patterns') &&
            <div className="small row totals commercial">
              <span className="col-md-6"><i className="fa fa-arrows-h"></i>{commercialTotalDistance}</span>
              <span className="col-md-6"><i className="fa fa-clock-o"></i>{commercialTotalTime}</span>
            </div>
          }
          <div className={this.props.value.deletable ? 'btn-group disabled' : 'btn-group'}>
            <div
              className={this.props.value.deletable ? 'btn dropdown-toggle disabled' : 'btn dropdown-toggle'}
              data-toggle='dropdown'
              >
              <span className='fa fa-cog'></span>
            </div>
            <ul className='dropdown-menu'>
              <li>
                <button
                  type='button'
                  onClick={this.props.onOpenEditModal}
                  data-toggle='modal'
                  data-target='#JourneyPatternModal'
                  >
                  {this.props.editMode ? I18n.t('actions.edit') : I18n.t('actions.show')}
                </button>
              </li>
              <li className={this.props.value.object_id ? '' : 'disabled'}>
                {this.vehicleJourneyURL(this.props.value.object_id)}
              </li>
              <li className={'delete-action' + (this.isDisabled('destroy') || !this.props.editMode ? ' disabled' : '')}>
                <button
                  type='button'
                  className="disabled"
                  disabled={this.isDisabled('destroy') || !this.props.editMode}
                  onClick={(e) => {
                    e.preventDefault()
                    this.props.onDeleteJourneyPattern(this.props.index)}
                  }
                  >
                    <span className='fa fa-trash'></span>{I18n.t('actions.destroy')}
                  </button>
                </li>
              </ul>
            </div>
          </div>

          {this.props.value.stop_points.map((stopPoint, i) =>{
            let costs = null
            let costsKey = null
            let time = null
            let distance = null
            let time_in_words = null
            if(this.previousSpId && stopPoint.checked){
              [costsKey, costs, time, distance] = this.getTimeAndDistanceBetweenStops(this.previousSpId, stopPoint.id)
              time_in_words = this.formatTime(time)
            }
            if(stopPoint.checked){
              this.previousSpId = stopPoint.id
            }
            let headlined = this.cityNameChecker(stopPoint, i)
            return (
              <div key={i} className={(stopPoint.checked ? 'activated' : 'deactivated') + (this.props.editMode ? ' edit-mode' : '')}>
                <div className={'td' + (headlined ? ' with-headline' : '')}>
                  {this.spNode(stopPoint, headlined)}
                </div>
                {this.hasFeature('costs_in_journey_patterns') && costs && <div className='costs' id={'costs-' + this.props.value.id + '-' + costsKey }>
                  {this.props.editMode && <div>
                    <p>
                      <input type="number" value={costs['distance'] || 0} min='0' name="distance" step="0.01" onChange={this.updateCosts} data-costs-key={costsKey}/>
                      <span>km</span>
                    </p>
                    <p>
                      <input type="number" value={costs['time'] || 0} min='0' name="time" onChange={this.updateCosts} data-costs-key={costsKey}/>
                      <span>min</span>
                    </p>
                  </div>}
                  {!this.props.editMode && <div>
                    <p><i className="fa fa-arrows-h"></i>{this.formatDistance(costs['distance'] || 0)}</p>
                    <p><i className="fa fa-clock-o"></i>{time_in_words}</p>
                  </div>}
                </div>}
              </div>
            )
          })}
        </div>
      )
  }
}

JourneyPattern.propTypes = {
  value: PropTypes.object,
  index: PropTypes.number,
  onCheckboxChange: PropTypes.func.isRequired,
  onOpenEditModal: PropTypes.func.isRequired,
  onDeleteJourneyPattern: PropTypes.func.isRequired,
  journeyPatterns: PropTypes.object.isRequired,
  fetchRouteCosts: PropTypes.func.isRequired
}
