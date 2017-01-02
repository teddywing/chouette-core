const modal = (state = {}, action) => {
  switch (action.type) {
    case 'EDIT_JOURNEYPATTERN_MODAL':
      return {
        edit: true,
        create: false,
        modalProps: {
          index: action.index,
          journeyPattern: action.journeyPattern
        }
      }
    case 'CREATE_JOURNEYPATTERN_MODAL':
      return {
        create: true,
        edit: false,
        modalProps: { index: action.index }
      }
    case 'DELETE_JOURNEYPATTERN':
      return Object.assign({}, state, { edit: false, create: false })
    case 'SAVE_MODAL':
      return Object.assign({}, state, { edit: false, create: false })
    case 'CLOSE_MODAL':
      return {
        edit: false,
        create: false,
        modalProps: {}
      }
    default:
      return state
  }
}

module.exports = modal
