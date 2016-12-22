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
          index: action.index,
          journeyPattern: {
            name: action.journeyPattern.name,
            object_id: action.journeyPattern.object_id,
            published_name: action.journeyPattern.published_name,
            registration_number: action.journeyPattern.registration_number,
            stop_points: action.journeyPattern.stop_points,
            deletable: true
          }
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
