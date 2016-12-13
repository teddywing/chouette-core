var actions = require("../actions")

const journeyPatterns = (state = {}, action) => {
  switch (action.type) {
    case 'RECEIVE_JOURNEY_PATTERNS':
      return [...action.json]
    case 'LOAD_FIRST_PAGE':
      actions.fetchJourneyPatterns(action.dispatch)
    case 'GO_TO_PREVIOUS_PAGE':
      if(state.page >= 0){
        actions.fetchJourneyPatterns()
      }
      return state
    case 'GO_TO_NEXT_PAGE':
      actions.fetchJourneyPatterns()
    default:
      return state
  }
}

module.exports = journeyPatterns
