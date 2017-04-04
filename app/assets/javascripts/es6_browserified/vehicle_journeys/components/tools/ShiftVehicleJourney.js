var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes
var actions = require('../../actions')

class ShiftVehicleJourney extends Component {
  constructor(props) {
    super(props)
  }

  handleSubmit() {
    if(actions.validateFields(this.refs) == true) {
      this.props.onShiftVehicleJourney(this.refs)
      this.props.onModalClose()
      $('#ShiftVehicleJourneyModal').modal('hide')
    }
  }

  render() {
    if(this.props.status.isFetching == true) {
      return false
    }
    if(this.props.status.fetchSuccess == true) {
      return (
        <li className='st_action'>
          <button
            type='button'
            disabled={(actions.getSelected(this.props.vehicleJourneys).length == 1 && this.props.filters.policy['vehicle_journeys.edit']) ? '' : 'disabled'}
            data-toggle='modal'
            data-target='#ShiftVehicleJourneyModal'
            onClick={this.props.onOpenShiftModal}
          >
            <span className='sb sb-update-vj'></span>
          </button>

          <div className={ 'modal fade ' + ((this.props.modal.type == 'shift') ? 'in' : '') } id='ShiftVehicleJourneyModal'>
            <div className='modal-container'>
              <div className='modal-dialog'>
                <div className='modal-content'>
                  <div className='modal-header'>
                    <h4 className='modal-title'>Mettre à jour une course</h4>
                    {(this.props.modal.type == 'shift') && (
                      <em>Mettre à jour les horaires de la course {actions.getSelected(this.props.vehicleJourneys)[0].objectid}</em>
                    )}
                  </div>

                  {(this.props.modal.type == 'shift') && (
                    <form>
                      <div className='modal-body'>
                        <div className='row'>
                          <div className='col-lg-4 col-lg-offset-4 col-md-4 col-md-offset-4 col-sm-4 col-sm-offset-4 col-xs-12'>
                            <div className='form-group'>
                              <label className='control-label is-required'>Avec un décalage de</label>
                              <input
                                type='number'
                                ref='additional_time'
                                min='0'
                                max='59'
                                className='form-control'
                                onKeyDown={(e) => actions.resetValidation(e.currentTarget)}
                                required
                                />
                            </div>
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

ShiftVehicleJourney.propTypes = {
  onOpenShiftModal: PropTypes.func.isRequired,
  onModalClose: PropTypes.func.isRequired,
  filters: PropTypes.object.isRequired
}

module.exports = ShiftVehicleJourney
