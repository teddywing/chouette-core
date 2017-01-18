var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes
var actions = require('../actions')

class EditModal extends Component {
  constructor(props) {
    super(props)
  }

  handleSubmit() {
    if(actions.validateFields(this.refs) == true) {
      this.props.saveModal(this.props.modal.modalProps.index, this.refs)
      $('#JourneyPatternModal').modal('hide')
    }
  }

  render() {
    return (
      <div className={ 'modal fade ' + ((this.props.modal.type == 'edit') ? 'in' : '') } id='JourneyPatternModal'>
        <div className='modal-dialog'>
          <div className='modal-content'>
            <div className='modal-header clearfix'>
              <h4 className='pull-left'>
                Modifier la mission
                {(this.props.modal.type == 'edit') && (
                  <em> "{this.props.modal.modalProps.journeyPattern.name}"</em>
                )}
              </h4>
              <div className='btn-group btn-group-sm pull-right'>
                <button
                  type='button'
                  className='btn btn-primary dropdown-toggle'
                  data-toggle='dropdown'
                  >
                  <span className='fa fa-bars'></span>
                  <span className='caret'></span>
                </button>

                <ul className='dropdown-menu'>
                  <li><a href='#'>Horaires des courses</a></li>
                  <li>
                    <a
                      href='#'
                      data-dismiss='modal'
                      onClick={(e) => {
                        e.preventDefault()
                        this.props.onDeleteJourneyPattern(this.props.modal.modalProps.index)}
                      }
                      >
                      Supprimer la mission
                    </a>
                  </li>
                </ul>
              </div>
            </div>

            {(this.props.modal.type == 'edit') && (
              <form>
                <div className='modal-body'>
                  <div className='form-group'>
                    <label className='control-label is-required'>Nom</label>
                    <input
                      type='text'
                      ref='name'
                      className='form-control'
                      id={this.props.modal.modalProps.index}
                      defaultValue={this.props.modal.modalProps.journeyPattern.name}
                      onKeyDown={(e) => actions.resetValidation(e.currentTarget)}
                      required
                      />
                  </div>

                  <div className='row'>
                    <div className='col-lg-6 col-md-6 col-sm-6 col-xs-6'>
                      <div className='form-group'>
                        <label className='control-label is-required'>Nom public</label>
                        <input
                          type='text'
                          ref='published_name'
                          className='form-control'
                          id={this.props.modal.modalProps.index}
                          defaultValue={this.props.modal.modalProps.journeyPattern.published_name}
                          onKeyDown={(e) => actions.resetValidation(e.currentTarget)}
                          required
                          />
                      </div>
                    </div>
                    <div className='col-lg-6 col-md-6 col-sm-6 col-xs-6'>
                      <div className='form-group'>
                        <label className='control-label is-required'>N° d'enregistrement</label>
                        <input
                          type='text'
                          ref='registration_number'
                          className='form-control'
                          id={this.props.modal.modalProps.index}
                          defaultValue={this.props.modal.modalProps.journeyPattern.registration_number}
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
    )
  }
}

EditModal.propTypes = {
  index: PropTypes.number,
  modal: PropTypes.object,
  onModalClose: PropTypes.func.isRequired,
  saveModal: PropTypes.func.isRequired,
  onDeleteJourneyPattern: PropTypes.func.isRequired
}

module.exports = EditModal
