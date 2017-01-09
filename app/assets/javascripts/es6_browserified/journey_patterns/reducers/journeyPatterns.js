var actions = require("../actions")

const journeyPattern = (state = {}, action) => {
  switch (action.type) {
    case 'ADD_JOURNEYPATTERN':
      let stopPoints = JSON.parse(JSON.stringify(state[0].stop_points))
      stopPoints.map((s)=>{
        s.checked = false
        return s
      })
      return {
        name: action.data.name.value,
        published_name: action.data.published_name.value,
        registration_number: action.data.registration_number.value,
        stop_points: stopPoints,
        deletable: false
      }
    case 'UPDATE_CHECKBOX_VALUE':
      var updatedStopPoints = state.stop_points.map((s) => {
        if (String(s.id) == action.id) {
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

const journeyPatterns = (state = [], action) => {
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
        if(i == action.index) {
          return journeyPattern(j, action)
        } else {
          return j
        }
      })
    case 'DELETE_JOURNEYPATTERN':
      return state.map((j, i) =>{
        if(i == action.index) {
          return Object.assign({}, j, {deletable: true})
        } else {
          return j
        }
      })
    case 'ADD_JOURNEYPATTERN':
      return [
        ...state,
        journeyPattern(state, action)
      ]
    case 'SAVE_MODAL':
      return state.map((j, i) =>{
        if(i == action.index) {
          return Object.assign({}, j, {
            name: action.data.name.value,
            published_name: action.data.published_name.value,
            registration_number: action.data.registration_number.value
          })
        } else {
          return j
        }
      })
    case 'SAVE_PAGE':
      actions.submitJourneyPattern(action.dispatch, state)
    default:
      return state
  }
}

module.exports = journeyPatterns
