import addInput from '../form_helper'

const todo = (state = {}, action, length) => {
  switch (action.type) {
    case 'ADD_STOP':
      return {
        text: '',
        index: length
      }
    case 'UPDATE_INPUT_VALUE':
      console.log('reducer', action)
      if (state.index !== action.index) {
        return state
      }

      return Object.assign(
        {},
        state,
        {text: action.text.text, stoparea_id: action.text.stoparea_id}
      )
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

const todos = (state = [], action) => {
  switch (action.type) {
    case 'ADD_STOP':
      return [
        ...state,
        todo(undefined, action, state.length)
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
        ...state.slice(action.index + 1).map((todo)=>{
          todo.index--
          return todo
        })
      ]
    case 'UPDATE_INPUT_VALUE':
      return state.map( (t, i) => {
        if (i === action.index) {
          updateFormForDeletion(t)
          return action.text
        } else {
          return t
        }
      })
      // return state.map(t =>
      //   todo(t, action)
      // )
    default:
      return state
  }
}

export default todos
