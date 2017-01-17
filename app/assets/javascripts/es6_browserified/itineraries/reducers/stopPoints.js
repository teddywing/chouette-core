var addInput = require('../form_helper')

const stopPoint = (state = {}, action, length) => {
  switch (action.type) {
    case 'ADD_STOP':
      return {
        text: '',
        index: length,
        for_boarding: 'normal',
        for_alighting: 'normal'
      }
    default:
      return state
  }
}
const updateFormForDeletion = (stop) =>{
  if (stop.stoppoint_id !== undefined){
    let now = Date.now()
    addInput('id', stop.stoppoint_id, now)
    addInput('_destroy', 'true', now)
  }
}

const stopPoints = (state = [], action) => {
  switch (action.type) {
    case 'ADD_STOP':
      return [
        ...state,
        stopPoint(undefined, action, state.length)
      ]
    case 'MOVE_STOP_UP':
      return [
        ...state.slice(0, action.index - 1),
        state[action.index],
        state[action.index - 1],
        ...state.slice(action.index + 1)
      ]
    case 'MOVE_STOP_DOWN':
      return [
        ...state.slice(0, action.index),
        state[action.index + 1],
        state[action.index],
        ...state.slice(action.index + 2)
      ]
    case 'DELETE_STOP':
      updateFormForDeletion(state[action.index])
      return [
        ...state.slice(0, action.index),
        ...state.slice(action.index + 1).map((stopPoint)=>{
          stopPoint.index--
          return stopPoint
        })
      ]
    case 'UPDATE_INPUT_VALUE':
      return state.map( (t, i) => {
        if (i === action.index) {
          updateFormForDeletion(t)
          return Object.assign(
            {},
            t,
            {stoppoint_id: "", text: action.text.text, stoparea_id: action.text.stoparea_id, user_objectid: action.text.user_objectid}
          )
        } else {
          return t
        }
      })
      // return state.map(t =>
      //   stopPoint(t, action)
      // )
    case 'UPDATE_SELECT_VALUE':
      return state.map( (t,i) => {
        if (i === action.index) {
          let stopState = Object.assign({}, t)
          stopState[action.select_id] = action.select_value
          return stopState
        } else {
          return t
        }
      })
    case 'TOGGLE_MAP':
      return state
    default:
      return state
  }
}

module.exports = stopPoints
