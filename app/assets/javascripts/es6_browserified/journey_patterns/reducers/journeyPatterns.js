var actions = require("../actions")

const journeyPattern = (state = {}, action) => {
  switch (action.type) {
    case 'UPDATE_CHECKBOX_VALUE':
      var updatedStopPoints = state.stop_points.map((s) => {
        if (s.id.toString() == action.id) {
          return Object.assign({}, s, {checked : !s.checked})
        }else {
          return s
        }
      })
      return Object.assign({}, state, {stop_points: updatedStopPoints})
    default:
      return state
  }
}

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
    case 'UPDATE_CHECKBOX_VALUE':
      return state.map((j, i) =>{
        if( i == action.index){
          return journeyPattern(j, action)
        }else{
          return j
        }
      })
    default:
      return state
  }
}

module.exports = journeyPatterns
