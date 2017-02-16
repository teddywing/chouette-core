const modal = (state = {}, action) => {
  switch (action.type) {
    case 'OPEN_CONFIRM_MODAL':
      $('#ConfirmModal').modal('show')
      return Object.assign({}, state, {
        type: 'confirm',
        confirmModal: {
          callback: action.callback,
        }
      })
    case 'CREATE_VEHICLEJOURNEY_MODAL':
      return {
        type: 'create',
        modalProps: {},
        confirmModal: {}
      }
    case 'CLOSE_MODAL':
      return {
        type: '',
        modalProps: {},
        confirmModal: {}
      }
    default:
      return state
  }
}

module.exports = modal
