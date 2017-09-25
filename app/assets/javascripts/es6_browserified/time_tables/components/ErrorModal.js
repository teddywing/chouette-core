var React = require('react')
var { PropTypes } = require('react')
var { errorModalMessage } = require('../actions')

const ErrorModal = ({dispatch, modal, onModalClose}, {I18n}) => (
  <div className={ 'modal fade ' + ((modal.type == 'error') ? 'in' : '') } id='ErrorModal'>
    <div className='modal-container'>
      <div className='modal-dialog'>
        <div className='modal-content'>
          <div className='modal-header'>
            <h4 className='modal-title'>{I18n.time_tables.edit.error_modal.title}</h4>
          </div>
          <div className='modal-body'>
            <div className='mt-md mb-md'>
              <p>{errorModalMessage(modal.modalProps.error)}</p>
            </div>
          </div>
          <div className='modal-footer'>
            <button
              className='btn btn-link'
              data-dismiss='modal'
              type='button'
              onClick= {() => {onModalClose()}}
              >
              {I18n.back}
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
)

ErrorModal.propTypes = {
  modal: PropTypes.object.isRequired,
  onModalClose: PropTypes.func.isRequired
}

ErrorModal.contextTypes = {
  I18n: PropTypes.object
}

module.exports = ErrorModal
