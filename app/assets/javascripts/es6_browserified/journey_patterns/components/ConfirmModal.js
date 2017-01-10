var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes

const ConfirmModal = ({dispatch, modal, onModalAccept, onModalCancel, journeyPatterns}) => (
  <div className={ 'modal fade ' + ((modal.type == 'confirm') ? 'in' : '') } id='ConfirmModal'>
    <div className='modal-dialog'>
      <div className='modal-content'>
        <div className='modal-body'>
          <p> Voulez-vous enregistrer vos modifications avant de changer de page? </p>
        </div>
        <div className='modal-footer'>
          <button
            className='btn btn-default'
            data-dismiss='modal'
            type='button'
            onClick= {() => {onModalCancel(modal.confirmModal.callback)}}
            >
            Ne pas enregistrer
          </button>
          <button
            className='btn btn-danger'
            data-dismiss='modal'
            type='button'
            onClick = {() => {onModalAccept(modal.confirmModal.callback, journeyPatterns)}}
            >
            Enregistrer
          </button>
        </div>
      </div>
    </div>
  </div>
)

ConfirmModal.propTypes = {
  modal: PropTypes.object.isRequired,
  onModalAccept: PropTypes.func.isRequired,
  onModalCancel: PropTypes.func.isRequired
}

module.exports = ConfirmModal
