var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes
var actions = require('../../actions')
var _ = require('lodash')

class DuplicateVehicleJourney extends Component {
  constructor(props) {
    super(props)
    this.state = {}
    this.onFormChange = this.onFormChange.bind(this)
    this.handleSubmit = this.handleSubmit.bind(this)
  }

  componentWillReceiveProps() {
    if (actions.getSelected(this.props.vehicleJourneys).length > 0) {
      let hour = parseInt(this.getDefaultValue('hour'))
      let miunte = parseInt(this.getDefaultValue('minute'))
      this.setState((state, props) => {
        return {
          originalDT: {
            hour: hour,
            minute: miunte
          },
          duplicate_time_hh: hour,
          duplicate_time_mm: miunte,
          additional_time: 0,
          duplicate_number: 1
        }
      })
    }
  }

  handleSubmit() {
    if(actions.validateFields(this.refs) == true) {
      let newDeparture = {
        departure_time : {
          hour: this.state.duplicate_time_hh,
          minute: this.state.duplicate_time_mm
        }
      }
      let val = actions.getDuplicateDelta(_.find(actions.getSelected(this.props.vehicleJourneys)[0].vehicle_journey_at_stops, {'dummy': false}), newDeparture)
      this.props.onDuplicateVehicleJourney(this.state.additional_time, this.state.duplicate_number, val)
      this.props.onModalClose()
      $('#DuplicateVehicleJourneyModal').modal('hide')
    }
  }

  onFormChange(e) {
    let {name, value} = e.target
    this.setState((state, props) => {
      return {
        [name]: parseInt(value)
      }
    })
  }

  getDefaultValue(type) {
    let vjas = _.find(actions.getSelected(this.props.vehicleJourneys)[0].vehicle_journey_at_stops, {'dummy': false})
    return vjas.departure_time[type]
  }

  render() {
    if(this.props.status.isFetching == true) {
      return false
    }
    if(this.props.status.fetchSuccess == true && actions.getSelected(this.props.vehicleJourneys).length > 0) {
      return (
        <li  className='st_action'>
          <button
            type='button'
            disabled={((actions.getSelected(this.props.vehicleJourneys).length >= 1 && this.props.filters.policy['vehicle_journeys.update']) ? '' : 'disabled')}
            data-toggle='modal'
            data-target='#DuplicateVehicleJourneyModal'
            onClick={this.props.onOpenDuplicateModal}
          >
            <span className='fa fa-files-o'></span>
          </button>

          <div className={ 'modal fade ' + ((this.props.modal.type == 'duplicate') ? 'in' : '') } id='DuplicateVehicleJourneyModal'>
            <div className='modal-container'>
              <div className='modal-dialog'>
                <div className='modal-content'>
                  <div className='modal-header'>
                    <h4 className='modal-title'>
                      Dupliquer { actions.getSelected(this.props.vehicleJourneys).length > 1 ? 'plusieurs courses' : 'une course' }
                    </h4>
                  </div>

                  {(this.props.modal.type == 'duplicate') && (
                    <form className='form-horizontal'>
                      <div className='modal-body'>
                        <div className={'form-group ' + (actions.getSelected(this.props.vehicleJourneys).length > 1 ? 'hidden' : '' )}>
                          <label className='control-label is-required col-sm-8'>Horaire de départ indicatif</label>
                          <span className="col-sm-4">
                            <span className={'input-group time' + (actions.getSelected(this.props.vehicleJourneys).length > 1 ? ' disabled' : '')}>
                              <input
                                type='number'
                                name='duplicate_time_hh'
                                ref='duplicate_time_hh'
                                min='00'
                                max='23'
                                className='form-control'
                                value={this.state.duplicate_time_hh}
                                onChange={e => this.onFormChange(e)}
                                disabled={actions.getSelected(this.props.vehicleJourneys) && (actions.getSelected(this.props.vehicleJourneys).length > 1 ? 'disabled' : '')}
                                />
                              <span>:</span>
                              <input
                                type='number'
                                name='duplicate_time_mm'
                                ref='duplicate_time_mm'
                                min='00'
                                max='59'
                                className='form-control'
                                value={this.state.duplicate_time_mm}
                                onChange={e => this.onFormChange(e)}
                                disabled={actions.getSelected(this.props.vehicleJourneys) && (actions.getSelected(this.props.vehicleJourneys).length > 1 ? 'disabled' : '')}
                                />
                            </span>
                          </span>
                        </div>

                        <div className='form-group'>
                          <label className='control-label is-required col-sm-8'>Nombre de courses à créer et dupliquer</label>
                          <div className="col-sm-4">
                            <input
                              type='number'
                              style={{'width': 104}}
                              name='duplicate_number'
                              ref='duplicate_number'
                              min='1'
                              max='20'
                              value={this.state.duplicate_number}
                              className='form-control'
                              onChange={e => this.onFormChange(e)}
                              onKeyDown={(e) => actions.resetValidation(e.currentTarget)}
                              required
                              />
                          </div>
                        </div>

                        <div className='form-group'>
                          <label className='control-label is-required col-sm-8'>Décalage à partir duquel on créé les courses</label>
                          <span className="col-sm-4">
                            <input
                              type='number'
                              style={{'width': 104}}
                              name='additional_time'
                              ref='additional_time'
                              min='-720'
                              max='720'
                              value={this.state.additional_time}
                              className='form-control disabled'
                              onChange={e => this.onFormChange(e)}
                              onKeyDown={(e) => actions.resetValidation(e.currentTarget)}
                              required
                            />
                          </span>
                        </div>
                      </div>

                      <div className='modal-footer'>
                        <button
                          className='btn btn-link'
                          data-dismiss='modal'
                          type='button'
                          onClick={this.props.onModalClose}
                          >
                          Annuler
                        </button>
                        <button
                          className={'btn btn-primary ' + (this.state.additional_time == 0 && this.state.originalDT.hour == this.state.duplicate_time_hh && this.state.originalDT.minute == this.state.duplicate_time_mm ? 'disabled' : '')}
                          type='button'
                          onClick={this.handleSubmit}
                          >
                          Valider
                        </button>
                      </div>
                    </form>
                  )}
                </div>
              </div>
            </div>
          </div>
        </li>
      )
    } else {
      return false
    }
  }
}

DuplicateVehicleJourney.propTypes = {
  onOpenDuplicateModal: PropTypes.func.isRequired,
  onModalClose: PropTypes.func.isRequired,
  filters: PropTypes.object.isRequired
}

module.exports = DuplicateVehicleJourney
