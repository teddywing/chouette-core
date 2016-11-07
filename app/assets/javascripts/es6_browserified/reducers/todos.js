const todo = (state = {}, action) => {
  switch (action.type) {
    case 'ADD_STOP':
      return {
        text: '',
        id: action.id
      }
    case 'UPDATE_INPUT_VALUE':
      if (state.id !== action.index) {
        return state
      }

      // console.log('action', action)
      // console.log('state', state)
      return Object.assign(
        {},
        state,
        {text: action.text}
      )
    default:
      return state
  }
}

const todos = (state = [], action) => {
  switch (action.type) {
    case 'ADD_STOP':
      return [
        ...state,
        todo(undefined, action)
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
      return [
        ...state.slice(0, action.index),
        ...state.slice(action.index + 1)
      ]
    case 'UPDATE_INPUT_VALUE':
      return state.map(t =>
        todo(t, action)
      )
    default:
      return state
  }
}

module.exports = todos
