import React, { PropTypes } from 'react'

export default function ConfirmModal({dispatch, modal, onModalAccept, onModalCancel, journeyPatterns}) {
  return (
    <div className={'modal fade ' + ((modal.type == 'confirm') ? 'in' : '')} id='ConfirmModal'>
      <div className='modal-container'>
        <div className='modal-dialog'>
          <div className='modal-content'>
            <div className='modal-header'>
              <h4 className='modal-title'>Confirmation</h4>
            </div>
            <div className='modal-body'>
              <div className='mt-md mb-md'>
                <p>Vous vous apprêtez à changer de page. Voulez-vous valider vos modifications avant cela ?</p>
              </div>
            </div>
            <div className='modal-footer'>
              <button
                className='btn btn-link'
                data-dismiss='modal'
                type='button'
                onClick={() => { onModalCancel(modal.confirmModal.callback) }}
              >
                Ne pas valider
            </button>
              <button
                className='btn btn-primary'
                data-dismiss='modal'
                type='button'
                onClick={() => { onModalAccept(modal.confirmModal.callback, journeyPatterns) }}
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

ConfirmModal.propTypes = {
  modal: PropTypes.object.isRequired,
  onModalAccept: PropTypes.func.isRequired,
  onModalCancel: PropTypes.func.isRequired
}