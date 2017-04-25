var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes
var actions = require('../../actions')
var CompanySelect2 = require('./select2s/CompanySelect2')

class EditVehicleJourney extends Component {
  constructor(props) {
    super(props)
  }

  handleSubmit() {
    if(actions.validateFields(this.refs) == true) {
      this.props.onEditVehicleJourney(this.refs, this.props.modal.modalProps.selectedCompany)
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
        <li className='st_action'>
          <button
            type='button'
            disabled={(actions.getSelected(this.props.vehicleJourneys).length == 1 && this.props.filters.policy['vehicle_journeys.edit']) ? '' : 'disabled'}
            data-toggle='modal'
            data-target='#EditVehicleJourneyModal'
            onClick={() => this.props.onOpenEditModal(actions.getSelected(this.props.vehicleJourneys)[0])}
          >
            <span className='fa fa-info'></span>
          </button>

          <div className={ 'modal fade ' + ((this.props.modal.type == 'duplicate') ? 'in' : '') } id='EditVehicleJourneyModal'>
            <div className='modal-container'>
              <div className='modal-dialog'>
                <div className='modal-content'>
                  <div className='modal-header'>
                    <h4 className='modal-title'>Informations</h4>
                  </div>

                  {(this.props.modal.type == 'edit') && (
                    <form>
                      <div className='modal-body'>
                        <div className='row'>
                          <div className='col-lg-6 col-md-6 col-sm-6 col-xs-12'>
                            <div className='form-group'>
                              <label className='control-label is-required'>Intitulé de la course</label>
                              <input
                                type='text'
                                ref='published_journey_name'
                                className='form-control'
                                defaultValue={this.props.modal.modalProps.vehicleJourney.published_journey_name}
                                onKeyDown={(e) => actions.resetValidation(e.currentTarget)}
                                required
                                />
                            </div>
                          </div>
                          <div className='col-lg-6 col-md-6 col-sm-6 col-xs-12'>
                            <div className='form-group'>
                              <label className='control-label'>Mission</label>
                              <input
                                type='text'
                                className='form-control'
                                value={(this.props.modal.modalProps.vehicleJourney.journey_pattern.objectid) + ' - ' + (this.props.modal.modalProps.vehicleJourney.journey_pattern.name)}
                                disabled={true}
                              />
                            </div>
                          </div>
                        </div>

                        <div className='row'>
                          <div className='col-lg-6 col-md-6 col-sm-6 col-xs-12'>
                            <div className='form-group'>
                              <label className='control-label is-required'>Numéro de train</label>
                              <input
                                type='text'
                                ref='published_journey_identifier'
                                className='form-control'
                                defaultValue={this.props.modal.modalProps.vehicleJourney.published_journey_identifier}
                                onKeyDown={(e) => actions.resetValidation(e.currentTarget)}
                                required
                              />
                            </div>
                          </div>
                          <div className='col-lg-6 col-md-6 col-sm-6 col-xs-12'>
                            <div className='form-group'>
                              <label className='control-label'>Transporteur</label>
                              <CompanySelect2
                                company = {this.props.modal.modalProps.vehicleJourney.company}
                                onSelect2Company = {(e) => this.props.onSelect2Company(e)}
                              />
                            </div>
                          </div>
                        </div>

                        <div className='row'>
                          <div className='col-lg-6 col-md-6 col-sm-6 col-xs-12'>
                            <div className='form-group'>
                              <label className='control-label'>Mode de transport</label>
                              <input
                                type='text'
                                className='form-control'
                                value={this.props.modal.modalProps.vehicleJourney.transport_mode}
                                disabled={true}
                              />
                            </div>
                          </div>
                          <div className='col-lg-6 col-md-6 col-sm-6 col-xs-12'>
                            <div className='form-group'>
                              <label className='control-label'>Sous mode de transport</label>
                              <input
                                type='text'
                                className='form-control'
                                value={this.props.modal.modalProps.vehicleJourney.transport_submode}
                                disabled={true}
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

EditVehicleJourney.propTypes = {
  onOpenEditModal: PropTypes.func.isRequired,
  onModalClose: PropTypes.func.isRequired,
  filters: PropTypes.object.isRequired
}

module.exports = EditVehicleJourney
