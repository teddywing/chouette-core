import React, { PropTypes, Component } from 'react'
import actions from '../actions'

export default class EditModal extends Component {
  constructor(props) {
    super(props)
  }

  handleSubmit() {
    if(actions.validateFields(this.refs) == true) {
      this.props.saveModal(this.props.modal.modalProps.index, this.refs)
      $('#JourneyPatternModal').modal('hide')
    }
  }

  renderModalTitle() {
    if (this.props.editMode) {
      return (
        <h4 className='modal-title'>
          Editer la mission
          {this.props.modal.type == 'edit' && <em> "{this.props.modal.modalProps.journeyPattern.name}"</em>}
        </h4>
      )
    } else {
      return <h4 className='modal-title'> Informations </h4>
    }
  }

  render() {
    return (
      <div className={ 'modal fade ' + ((this.props.modal.type == 'edit') ? 'in' : '') } id='JourneyPatternModal'>
        <div className='modal-container'>
          <div className='modal-dialog'>
            <div className='modal-content'>
              <div className='modal-header'>
                {this.renderModalTitle()}
                <span type="button" className="close modal-close" data-dismiss="modal">&times;</span>
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
                        disabled={!this.props.editMode}
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
                            disabled={!this.props.editMode}
                            id={this.props.modal.modalProps.index}
                            defaultValue={this.props.modal.modalProps.journeyPattern.published_name}
                            onKeyDown={(e) => actions.resetValidation(e.currentTarget)}
                            required
                            />
                        </div>
                      </div>
                      <div className='col-lg-6 col-md-6 col-sm-6 col-xs-6'>
                        <div className='form-group'>
                          <label className='control-label'>Code mission</label>
                          <input
                            type='text'
                            ref='registration_number'
                            className='form-control'
                            disabled={!this.props.editMode}
                            id={this.props.modal.modalProps.index}
                            defaultValue={this.props.modal.modalProps.journeyPattern.registration_number}
                            onKeyDown={(e) => actions.resetValidation(e.currentTarget)}
                            />
                        </div>
                      </div>
                    </div>
                  </div>
                  {
                    this.props.editMode &&
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
                  }
                </form>
              )}
            </div>
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
  saveModal: PropTypes.func.isRequired
}