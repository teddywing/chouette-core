const updatedJourneyPattern = (state = {}, action) => {
  switch (action.type) {
    case 'DELETE_JOURNEYPATTERN_MODAL':
      return Object.assign({}, state, { deletable: true })
    case 'SAVE_MODAL':
      return Object.assign({}, state, {
        name: action.data.name.value,
        published_name: action.data.published_name.value,
        registration_number: action.data.registration_number.value
      })
    default:
      return state
  }
}

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
    case 'DELETE_JOURNEYPATTERN_MODAL':
      return Object.assign({}, state, {
        modalProps: {
          index: state.modalProps.index,
          journeyPattern: updatedJourneyPattern(state.modalProps.journeyPattern, action)
        }
      })
    case 'SAVE_MODAL':
      return Object.assign({}, state, {
        open: false,
        modalProps: {
          index: state.modalProps.index,
          journeyPattern: updatedJourneyPattern(state.modalProps.journeyPattern, action)
        }
      })
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
