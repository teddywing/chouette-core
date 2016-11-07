const todo = (state = {}, action, length) => {
  switch (action.type) {
    case 'ADD_STOP':
      return {
        text: '',
        index: length
      }
    case 'UPDATE_INPUT_VALUE':
      if (state.index !== action.index) {
        return state
      }

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
        todo(undefined, action, state.length)
      ]
    case 'MOVE_STOP_UP':
      state[action.index].index = state[action.index - 1].index
      state[action.index - 1].index = state[action.index].index + 1
      return [
        ...state.slice(0, action.index - 1),
        state[action.index],
        state[action.index - 1],
        ...state.slice(action.index + 1)
      ]
    case 'MOVE_STOP_DOWN':
      state[action.index + 1].index = state[action.index].index
      state[action.index].index = state[action.index + 1].index + 1
      return [
        ...state.slice(0, action.index),
        state[action.index + 1],
        state[action.index],
        ...state.slice(action.index + 2)
      ]
    case 'DELETE_STOP':
      return [
        ...state.slice(0, action.index),
        ...state.slice(action.index + 1).map((todo)=>{
          todo.index--
          return todo
        })
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
