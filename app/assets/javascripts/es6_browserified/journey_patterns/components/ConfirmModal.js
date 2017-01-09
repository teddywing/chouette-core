var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes

const ConfirmModal = ({modal, onModal}) => (
  <div className={ 'modal fade ' + ((modal.type == 'confirm') ? 'in' : '') } id='ConfirmModal'>
    <div className='modal-dialog'>
      <div className='modal-content'>
        <div className='modal-body'>
          <p> Voulez-vous sauver vos modifications avant de blabblabla? </p>
        </div>
        <div className='modal-footer'>
          <button
            className='btn btn-default'
            data-dismiss='modal'
            type='button'
            onClick= {() => {onModal(modal.confirmModal.cancel)}}
            >
            Annuler
          </button>
          <button
            className='btn btn-danger'
            data-dismiss='modal'
            type='button'
            onClick = {() => {onModal(modal.confirmModal.accept)}}
            >
            Valider
          </button>
        </div>
      </div>
    </div>
  </div>
)

ConfirmModal.propTypes = {
  modal: PropTypes.object.isRequired,
  onModal: PropTypes.func.isRequired
}

module.exports = ConfirmModal
