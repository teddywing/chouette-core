const confirmModal = (state = {}, action) => {
  switch (action.type) {
    case 'OPEN_CONFIRM_MODAL':
      let modal = Object.assign( {}, state.modal,
        {
          confirmActions : {
            accept: action.accept,
            cancel: action.cancel
          },
          confirm: true
        }
      )
      return Object.assign({}, state, modal: modal)
    default:
      return state
  }
}

module.exports = confirmModal
