var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes
var actions = require('../../actions')
var _ = require('lodash')

class DuplicateVehicleJourney extends Component {
  constructor(props) {
    super(props)
  }

  handleSubmit() {
    if(actions.validateFields(this.refs) == true) {
      let newDeparture = {
        departure_time : {
          hour: this.refs.duplicate_time_hh.value,
          minute: this.refs.duplicate_time_mm.value
        }
      }
      let val = actions.getDuplicateDelta(_.find(actions.getSelected(this.props.vehicleJourneys)[0].vehicle_journey_at_stops, {'dummy': false}), newDeparture)
      this.refs.additional_time.value = parseInt(this.refs.additional_time.value) + val
      this.props.onDuplicateVehicleJourney(this.refs)
      this.props.onModalClose()
      $('#DuplicateVehicleJourneyModal').modal('hide')
    }
  }

  getDefaultValue(type) {
    let vjas = _.find(actions.getSelected(this.props.vehicleJourneys)[0].vehicle_journey_at_stops, {'dummy': false})
    return vjas.departure_time[type]
  }
  render() {
    if(this.props.status.isFetching == true) {
      return false
    }
    if(this.props.status.fetchSuccess == true) {
      return (
        <li  className='st_action'>
          <button
            type='button'
            disabled={((actions.getSelected(this.props.vehicleJourneys).length >= 1 && this.props.filters.policy['vehicle_journeys.edit']) ? '' : 'disabled')}
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
                    <h4 className='modal-title'>Dupliquer une course</h4>
                    {(this.props.modal.type == 'duplicate') && (
                      <em>Dupliquer les horaires de la course {actions.humanOID(actions.getSelected(this.props.vehicleJourneys)[0].objectid)}</em>
                    )}
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
                                ref='duplicate_time_hh'
                                min='00'
                                max='23'
                                className='form-control'
                                defaultValue={this.getDefaultValue('hour')}
                                disabled={(actions.getSelected(this.props.vehicleJourneys).length > 1 ? 'disabled' : '')}
                                />
                              <span>:</span>
                              <input
                                type='number'
                                ref='duplicate_time_mm'
                                min='00'
                                max='59'
                                className='form-control'
                                defaultValue={this.getDefaultValue('minute')}
                                disabled={(actions.getSelected(this.props.vehicleJourneys).length > 1 ? 'disabled' : '')}
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
                              ref='duplicate_number'
                              min='1'
                              max='20'
                              defaultValue='1'
                              className='form-control'
                              onKeyDown={(e) => actions.resetValidation(e.currentTarget)}
                              required
                              />
                          </div>
                        </div>

                        <div className='form-group'>
                          <label className='control-label is-required col-sm-8'>Décalage à partir duquel on créé les courses</label>
                          <div className="col-sm-4">
                            <input
                              type='number'
                              style={{'width': 104}}
                              ref='additional_time'
                              min='-59'
                              max='59'
                              defaultValue='0'
                              className='form-control'
                              onKeyDown={(e) => actions.resetValidation(e.currentTarget)}
                              required
                              />
                          </div>
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
                          className='btn btn-primary'
                          type='button'
                          onClick={this.handleSubmit.bind(this)}
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
