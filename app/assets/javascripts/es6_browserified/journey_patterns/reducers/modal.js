const modal = (state = {}, action) => {
  switch (action.type) {
    case 'OPEN_CONFIRM_MODAL':
      return Object.assign({}, state, {
        type: 'confirm',
        confirmModal: {
          accept: action.accept,
          cancel: action.cancel
        }
      })
    case 'EDIT_JOURNEYPATTERN_MODAL':
      return {
        type: 'edit',
        modalProps: {
          index: action.index,
          journeyPattern: action.journeyPattern
        }
      }
    case 'CREATE_JOURNEYPATTERN_MODAL':
      return {
        type: 'create',
        modalProps: { index: action.index }
      }
    case 'DELETE_JOURNEYPATTERN':
      return Object.assign({}, state, { type :'' })
    case 'SAVE_MODAL':
      return Object.assign({}, state, { type :''  })
    case 'CLOSE_MODAL':
      return {
        type: '',
        modalProps: {}
      }
    default:
      return state
  }
}

module.exports = modal
