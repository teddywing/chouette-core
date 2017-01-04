var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes

class CreateModal extends Component {
  constructor(props) {
    super(props)
  }
  handleSubmit(e) {
    e.preventDefault()
    this.props.onAddJourneyPattern((this.props.journeyPatterns.length + 1), this.refs)
  }

  render() {
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

        <div className={ 'modal fade ' + (this.props.modal.create ? 'in' : '') } id='NewJourneyPatternModal'>
          <div className='modal-dialog'>
            <div className='modal-content'>
              <div className='modal-header clearfix'>
                <h4>Ajouter une mission</h4>
              </div>

              <div className='modal-body'>
                {this.props.modal.create && (
                  <form>
                    <div className='form-group'>
                      <label>Nom</label>
                      <input
                        type='text'
                        ref='name'
                        className='form-control'
                        />
                    </div>
                    <div className='row'>
                      <div className='col-lg-6 col-md-6 col-sm-6 col-xs-6'>
                        <div className='form-group'>
                          <label>Nom public</label>
                          <input
                            type='text'
                            ref='published_name'
                            className='form-control'
                          />
                        </div>
                      </div>
                      <div className='col-lg-6 col-md-6 col-sm-6 col-xs-6'>
                        <div className='form-group'>
                          <label>N° d'enregistrement</label>
                          <input
                            type='text'
                            ref='registration_number'
                            className='form-control'
                          />
                        </div>
                      </div>
                    </div>
                  </form>
                )}
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
                  data-dismiss='modal'
                  type='button'
                  onClick={this.handleSubmit.bind(this)}
                  >
                  Valider
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  }
}

CreateModal.propTypes = {
  index: PropTypes.number,
  modal: PropTypes.object,
  onOpenCreateModal: PropTypes.func.isRequired,
  onModalClose: PropTypes.func.isRequired,
  onAddJourneyPattern: PropTypes.func.isRequired
}

module.exports = CreateModal
