const modal = (state = {}, action) => {
  switch (action.type) {
    case 'EDIT_JOURNEYPATTERN_MODAL':
      return {
        open: true,
        modalProps: {
          index: action.index,
          journeyPattern: action.journeyPattern
        }
      }
    case 'DELETE_JOURNEYPATTERN':
      return Object.assign({}, state, { open: false })
    case 'SAVE_MODAL':
      return Object.assign({}, state, { open: false })
    case 'CLOSE_MODAL':
      return {
        open: false,
        modalProps: {}
      }
    default:
      return state
  }
}

module.exports = modal
