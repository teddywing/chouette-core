const modal = (state = {}, action) => {
  switch (action.type) {
    case 'UPDATE_JOURNEYPATTERN_MODAL':
      return {
        open: true,
        modalProps: {
          index: action.index,
          journeyPattern: action.journeyPattern
        }
      }
    case 'HIDE_MODAL':
      return {}
    default:
      return state
  }
}

module.exports = modal
