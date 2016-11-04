let nextTodoId = 0
module.exports = {

  addStop : () => {
    return {
      type: 'ADD_STOP',
      id: nextTodoId++
    }
  },

  moveStopUp : (index) => {
    return {
      type: 'MOVE_STOP_UP',
      index
    }
  },

  moveStopDown : (index) => {
    return {
      type: 'MOVE_STOP_DOWN',
      index
    }
  },

  deleteStop: (index) => {
    return {
      type: 'DELETE_STOP',
      index
    }
  }
}
