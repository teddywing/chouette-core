var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes
var actions = require('../../actions')

class EditVehicleJourney extends Component {
  constructor(props) {
    super(props)
  }

  handleSubmit() {
    if(actions.validateFields(this.refs) == true) {
      this.props.onEditVehicleJourney(this.refs)
      this.props.onModalClose()
      $('#EditVehicleJourneyModal').modal('hide')
    }
  }

  render() {
    if(this.props.status.isFetching == true) {
      return false
    }
    if(this.props.status.fetchSuccess == true) {
      return (
        <div  className='pull-left'>
          <button
            disabled= {(actions.getSelected(this.props.vehicleJourneys).length == 1 && this.props.filters.policy['vehicle_journeys.edit']) ? false : true}
            type='button'
            className='btn btn-primary btn-sm'
            data-toggle='modal'
            data-target='#EditVehicleJourneyModal'
            onClick={() => this.props.onOpenEditModal(actions.getSelected(this.props.vehicleJourneys)[0])}
            >
            <span className='fa fa-pencil'></span>
            </button>

            <div className={ 'modal fade ' + ((this.props.modal.type == 'duplicate') ? 'in' : '') } id='EditVehicleJourneyModal'>
              <div className='modal-dialog'>
                <div className='modal-content'>
                  <div className='modal-header clearfix'>
                    <h4>Informations</h4>
                  </div>

                  {(this.props.modal.type == 'edit') && (
                    <form>
                      <div className='modal-body'>
                        <div className='form-group'>
                          <label className='control-label is-required'>Nom</label>
                          <input
                            type='text'
                            ref='comment'
                            className='form-control'
                            defaultValue={this.props.modal.modalProps.vehicleJourney.comment}
                            onKeyDown={(e) => actions.resetValidation(e.currentTarget)}
                            required
                            />
                        </div>

                        <div className='row'>
                          <div className='col-lg-6 col-md-6 col-sm-6 col-xs-6'>
                            <p>Mission
                              <span> {this.props.modal.modalProps.vehicleJourney.journey_pattern_id}</span>
                            </p>
                          </div>
                        </div>
                        <div className='row'>
                          <div className='col-lg-6 col-md-6 col-sm-6 col-xs-6'>
                            NUMERO DE TRAIN??
                          </div>
                        </div>
                        <div className='row'>
                          <div className='col-lg-6 col-md-6 col-sm-6 col-xs-6'>
                            TRANSPORTEUR??
                          </div>
                        </div>
                      </div>

                      <div className='modal-footer'>
                        <button
                          className='btn btn-default'
                          data-dismiss='modal'
                          type='button'
                          onClick={this.props.onModalClose}
                          >
                          Annuler
                        </button>
                        <button
                          className='btn btn-danger'
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
        )
    } else {
      return false
    }
  }
}

EditVehicleJourney.propTypes = {
  onOpenEditModal: PropTypes.func.isRequired,
  onModalClose: PropTypes.func.isRequired,
  filters: PropTypes.object.isRequired
}

module.exports = EditVehicleJourney
