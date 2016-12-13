const pagination = (state = 0, action) => {
  switch (action.type) {
    case 'GO_TO_PREVIOUS_PAGE':
      if (action.currentPage > 1){
        return state - 1
      }
      return state
    case 'GO_TO_NEXT_PAGE':
      if (window.journeyPatternLength - (action.currentPage * 12) > 0){
        return state + 1
      }
      return state
    default:
      return state
  }
}

module.exports = pagination
