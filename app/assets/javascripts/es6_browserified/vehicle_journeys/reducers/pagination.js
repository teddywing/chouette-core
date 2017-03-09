const pagination = (state = {}, action) => {
  switch (action.type) {
    case 'RECEIVE_JOURNEY_PATTERNS':
      return Object.assign({}, state, {stateChanged: false})
    case 'GO_TO_PREVIOUS_PAGE':
      if (action.pagination.page > 1){
        return Object.assign({}, state, {page : action.pagination.page - 1, stateChanged: false})
      }
      return state
    case 'GO_TO_NEXT_PAGE':
      if (state.totalCount - (action.pagination.page * action.pagination.perPage) > 0){
        return Object.assign({}, state, {page : action.pagination.page + 1, stateChanged: false})
      }
      return state
    case 'ADD_VEHICLEJOURNEY':
    case 'UPDATE_TIME':
      toggleOnConfirmModal('modal')
      return Object.assign({}, state, {stateChanged: true})
    case 'RESET_PAGINATION':
      return Object.assign({}, state, {page: 1, stateChanged: false})
    case 'UPDATE_TOTAL_COUNT':
      return Object.assign({}, state, {totalCount : state.totalCount - action.diff })
    default:
      return state
  }
}

const toggleOnConfirmModal = (arg = '') =>{
  $('.confirm').each(function(){
    $(this).data('toggle','')
  })
}

module.exports = pagination
