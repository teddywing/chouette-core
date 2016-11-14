export const addStop = () => {
  return {
    type: 'ADD_STOP'
  }
}
export const moveStopUp = (index) => {
  return {
    type: 'MOVE_STOP_UP',
    index
  }
}
export const moveStopDown = (index) => {
  return {
    type: 'MOVE_STOP_DOWN',
    index
  }
}
export const deleteStop = (index) => {
  return {
    type: 'DELETE_STOP',
    index
  }
}
export const updateInputValue = (index, text) => {
  return {
    type : "UPDATE_INPUT_VALUE",
    index,
    text
  }
}
