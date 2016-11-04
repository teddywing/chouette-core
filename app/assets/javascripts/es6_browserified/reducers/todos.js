const todo = (state = {}, action) => {
  console.log('action', action)
  switch (action.type) {
    case 'ADD_STOP':
      return {
        id: action.id
      }

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
    default:
      return state
  }
}

module.exports = todos
