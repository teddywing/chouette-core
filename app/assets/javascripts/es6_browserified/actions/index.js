module.exports = {
  addStop : () => {
    return {
      type: 'ADD_STOP'
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
  },
  updateInputValue: (index, text) => {
    console.log('action',index, text)
    return {
      type : "UPDATE_INPUT_VALUE",
      index,
      text
    }
  }
}
