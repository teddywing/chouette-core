import React, { Component } from 'react'
import PropTypes from 'prop-types'
import actions from '../actions'

export default class JourneyPattern extends Component{
  constructor(props){
    super(props)
    this.previousCity = undefined
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
      <a href={vjURL}>Horaires des courses</a>
    )
  }

  hasFeature(key) {
    return this.props.status.features[key]
  }

  cityNameChecker(sp) {
    let bool = false

    if(sp.city_name != this.previousCity){
      bool = true
      this.previousCity = sp.city_name
    }
    return bool
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
            id={sp.id}
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

  render() {
    this.previousCity = undefined
    this.previousSpId = undefined
    return (
      <div className={'t2e-item' + (this.props.value.deletable ? ' disabled' : '') + (this.props.value.object_id ? '' : ' to_record') + (this.props.value.errors ? ' has-error': '') + (this.hasFeature('costs_in_journey_patterns') ? ' with-costs' : '')}>
        {/* Errors */}
        {/* this.props.value.errors ? this.getErrors(this.props.value.errors) : '' */}

        <div className='th'>
          <div className='strong mb-xs'>{this.props.value.object_id ? this.props.value.short_id : '-'}</div>
          <div>{this.props.value.registration_number}</div>
          <div>{actions.getChecked(this.props.value.stop_points).length} arrêt(s)</div>

          <div className={this.props.value.deletable ? 'btn-group disabled' : 'btn-group'}>
            <div
              className={this.props.value.deletable ? 'btn dropdown-toggle disabled' : 'btn dropdown-toggle'}
              data-toggle='dropdown'
              >
              <span className='fa fa-cog'></span>
            </div>
            <ul className='dropdown-menu'>
              <li className={this.isDisabled('update') ? 'disabled' : ''}>
                <button
                  type='button'
                  disabled={this.isDisabled('update')}
                  onClick={this.props.onOpenEditModal}
                  data-toggle='modal'
                  data-target='#JourneyPatternModal'
                  >
                  {this.props.editMode ? 'Editer' : 'Consulter'}
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
                    <span className='fa fa-trash'></span>Supprimer
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
              costsKey = this.previousSpId + "-" + stopPoint.id
              costs = this.props.value.costs[costsKey] || {distance: 0, time: 0}
              time = costs['time'] || 0
              distance = costs['distance'] || 0
              if(time < 60){
                time_in_words = time + " min"
              }
              else{
                let hours = parseInt(time/60)
                time_in_words = hours + " h " + (time - 60*hours) + " min"
              }
            }
            if(stopPoint.checked){
              this.previousSpId = stopPoint.id
            }
            let headlined = this.cityNameChecker(stopPoint)
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
                    <p><i className="fa fa-arrows-h"></i>{(costs['distance'] || 0) + " km"}</p>
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
  onDeleteJourneyPattern: PropTypes.func.isRequired
}
