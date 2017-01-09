const pagination = (state = {}, action) => {
  switch (action.type) {
    case 'GO_TO_PREVIOUS_PAGE':
      if (action.currentPage > 1){
        return Object.assign({}, state, {page : action.currentPage - 1})
      }
      return state
    case 'GO_TO_NEXT_PAGE':
      if (state.totalCount - (action.currentPage * 12) > 0){
        return Object.assign({}, state, {page : action.currentPage + 1})
      }
      return state
    default:
      return state
  }
}

module.exports = pagination
