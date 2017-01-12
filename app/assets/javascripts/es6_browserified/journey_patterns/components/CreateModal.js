var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes
var actions = require('../actions')

class CreateModal extends Component {
  constructor(props) {
    super(props)
  }

  handleSubmit() {
    if(actions.validateFields(this.refs) == true) {
      this.props.onAddJourneyPattern(this.refs)
      $('#NewJourneyPatternModal').modal('hide')
    }
  }

  render() {
    if(status.fetchSuccess == true) {
      return (
        <div className='pull-right'>
          <button
            type='button'
            className='btn btn-primary btn-sm'
            data-toggle='modal'
            data-target='#NewJourneyPatternModal'
            onClick={this.props.onOpenCreateModal}
            >
            <span className='fa fa-plus'></span> Ajouter une mission
            </button>

            <div className={ 'modal fade ' + ((this.props.modal.type == 'create') ? 'in' : '') } id='NewJourneyPatternModal'>
              <div className='modal-dialog'>
                <div className='modal-content'>
                  <div className='modal-header clearfix'>
                    <h4>Ajouter une mission</h4>
                  </div>

                  {(this.props.modal.type == 'create') && (
                    <form>
                      <div className='modal-body'>
                        <div className='form-group'>
                          <label className='control-label'>Nom</label>
                          <input
                            type='text'
                            ref='name'
                            className='form-control'
                            onKeyDown={(e) => actions.resetValidation(e.currentTarget)}
                            required
                            />
                        </div>
                        <div className='row'>
                          <div className='col-lg-6 col-md-6 col-sm-6 col-xs-6'>
                            <div className='form-group'>
                              <label className='control-label'>Nom public</label>
                              <input
                                type='text'
                                ref='published_name'
                                className='form-control'
                                onKeyDown={(e) => actions.resetValidation(e.currentTarget)}
                                required
                                />
                            </div>
                          </div>
                          <div className='col-lg-6 col-md-6 col-sm-6 col-xs-6'>
                            <div className='form-group'>
                              <label className='control-label'>N° d'enregistrement</label>
                              <input
                                type='text'
                                ref='registration_number'
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

CreateModal.propTypes = {
  index: PropTypes.number,
  modal: PropTypes.object.isRequired,
  status: PropTypes.object.isRequired,
  onOpenCreateModal: PropTypes.func.isRequired,
  onModalClose: PropTypes.func.isRequired,
  onAddJourneyPattern: PropTypes.func.isRequired
}

module.exports = CreateModal
