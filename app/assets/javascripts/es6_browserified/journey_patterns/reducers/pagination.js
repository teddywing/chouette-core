const pagination = (state = {}, action) => {
  switch (action.type) {
    case 'RECEIVE_JOURNEY_PATTERNS':
      return Object.assign({}, state, {stateChanged: false})
    case 'GO_TO_PREVIOUS_PAGE':
      if (action.pagination.page > 1){
        toggleOnConfirmModal()
        return Object.assign({}, state, {page : action.pagination.page - 1, stateChanged: false})
      }
      return state
    case 'GO_TO_NEXT_PAGE':
      if (state.totalCount - (action.pagination.page * action.pagination.perPage) > 0){
        toggleOnConfirmModal()
        return Object.assign({}, state, {page : action.pagination.page + 1, stateChanged: false})
      }
      return state
    case 'UPDATE_CHECKBOX_VALUE':
    case 'ADD_JOURNEYPATTERN':
    case 'SAVE_MODAL':
      toggleOnConfirmModal('modal')
      return Object.assign({}, state, {stateChanged: true})
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
