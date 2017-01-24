const actions = {
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
  deleteStop : (index) => {
    return {
      type: 'DELETE_STOP',
      index
    }
  },
  updateInputValue : (index, text) => {
    return {
      type : 'UPDATE_INPUT_VALUE',
      index,
      text
    }
  },
  updateSelectValue: (e, index) => {
    return {
      type :'UPDATE_SELECT_VALUE',
      select_id: e.currentTarget.id,
      select_value: e.currentTarget.value,
      index
    }
  },
  toggleMap: (index) =>({
    type: 'TOGGLE_MAP',
    index
  }),
  selectMarker: (index, data) =>({
    type: 'SELECT_MARKER',
    index,
    data
  })
}

module.exports = actions
