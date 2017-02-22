var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes
var actions = require('../../actions')

class DuplicateVehicleJourney extends Component {
  constructor(props) {
    super(props)
  }

  handleSubmit() {
    if(actions.validateFields(this.refs) == true) {
      this.props.onDuplicateVehicleJourney(this.refs)
      $('#DuplicateVehicleJourneyModal').modal('hide')
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
            type='button'
            className='btn btn-primary btn-sm'
            data-toggle='modal'
            data-target='#DuplicateVehicleJourneyModal'
            onClick={this.props.onOpenDuplicateModal}
            >
            <span className='fa fa-files-o'></span>
            </button>

            <div className={ 'modal fade ' + ((this.props.modal.type == 'shift') ? 'in' : '') } id='DuplicateVehicleJourneyModal'>
              <div className='modal-dialog'>
                <div className='modal-content'>
                  <div className='modal-header clearfix'>
                    <h4>Mettre à jour une course</h4>
                  </div>

                  {(this.props.modal.type == 'shift') && (
                    <form>
                      <div className='modal-body'>
                        <div className='form-group'>
                          <label className='control-label is-required'>Mettre à jour les horaires de la course</label>
                          <select
                            ref='objectid'
                            className='form-control'
                            onKeyDown={(e) => actions.resetValidation(e.currentTarget)}
                            required
                            >
                            {this.props.vehicleJourneys.map((vj, i) =>
                              <option
                                key = {i}
                                value = {vj.objectid}>
                                {vj.objectid}
                              </option>
                            )}
                          </select>
                        </div>
                        <div className='row'>
                          <div className='col-lg-6 col-md-6 col-sm-6 col-xs-6'>
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

DuplicateVehicleJourney.propTypes = {
  onOpenDuplicateModal: PropTypes.func.isRequired,
  onModalClose: PropTypes.func.isRequired,
}

module.exports = DuplicateVehicleJourney
