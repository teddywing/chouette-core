var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes

class CreateModal extends Component {
  constructor(props) {
    super(props)
  }
  handleSubmit(e) {
    e.preventDefault()
    this.props.saveModal(this.props.modal.modalProps.index, this.refs)
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

        <div className={ (this.props.modal.create ? 'in' : '') + ' modal fade' } id='NewJourneyPatternModal'>
          <div className='modal-dialog'>
            <div className='modal-content'>
              <div className='modal-header clearfix'>
                <h4>Ajouter une mission</h4>
              </div>
              <div className='modal-body'>
                le formulaire arrive...
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
  saveModal: PropTypes.func.isRequired
}

module.exports = CreateModal
