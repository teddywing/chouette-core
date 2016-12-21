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
