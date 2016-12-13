var actions = require("../actions")

const journeyPatterns = (state = {}, action) => {
  switch (action.type) {
    case 'RECEIVE_JOURNEY_PATTERNS':
      return [...action.json]
    case 'LOAD_FIRST_PAGE':
      actions.fetchJourneyPatterns(action.dispatch)
    case 'GO_TO_PREVIOUS_PAGE':
      if(action.currentPage > 1){
        actions.fetchJourneyPatterns(action.dispatch, action.currentPage, action.nextPage)
      }
      return state
    case 'GO_TO_NEXT_PAGE':
      if (window.journeyPatternLength - (action.currentPage * 12) > 0){
        actions.fetchJourneyPatterns(action.dispatch, action.currentPage, action.nextPage)
      }
      return state
    default:
      return state
  }
}

module.exports = journeyPatterns
