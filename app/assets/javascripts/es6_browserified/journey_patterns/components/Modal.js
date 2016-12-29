var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes

class ModalComponent extends Component {
  constructor(props) {
    super(props)
  }
  handleSubmit(e) {
    e.preventDefault()
    this.props.saveModal(this.refs)
  }

  render() {
    return (
      <div className={ (this.props.modal.open ? 'in' : '') + ' modal fade' } id='JourneyPatternModal'>
        <div className='modal-dialog'>
          <div className='modal-content'>
            <div className='modal-header clearfix'>
              <h4 className='pull-left'>
                Modifier la mission
                {this.props.modal.open && (
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
                      onClick={(e) => {
                        e.preventDefault()
                        this.props.onDeleteJourneyPattern(this.props.modal.modalProps.index, this.props.modal.modalProps.journeyPattern)}
                      }
                      >
                      Supprimer la mission
                    </a>
                  </li>
                </ul>
              </div>
              {this.props.modal.open && (
                this.props.modal.modalProps.journeyPattern.deletable ?
                <div className='alert alert-danger' style={{clear: 'both', marginBottom: 0}}>La mission a été supprimée. Cette action sera effective après validation.</div>
                :
                ''
              )}
            </div>
            <div className='modal-body'>
              {this.props.modal.open && (
                <form>
                  <div className='form-group'>
                    <label>Nom</label>
                    <input
                      type='text'
                      ref='name'
                      className='form-control'
                      id={this.props.modal.modalProps.index}
                      defaultValue={this.props.modal.modalProps.journeyPattern.name}
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
                          id={this.props.modal.modalProps.index}
                          defaultValue={this.props.modal.modalProps.journeyPattern.published_name}
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
                          id={this.props.modal.modalProps.index}
                          defaultValue={this.props.modal.modalProps.journeyPattern.registration_number}
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
    )
  }
}

ModalComponent.propTypes = {
  index: PropTypes.number,
  modal: PropTypes.object,
  onModalClose: PropTypes.func.isRequired,
  saveModal: PropTypes.func.isRequired,
  onDeleteJourneyPattern: PropTypes.func.isRequired
}

module.exports = ModalComponent
