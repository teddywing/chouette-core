var actions = require("../actions")

const status = (state = [], action) => {
  switch (action.type) {
    case 'RECEIVE_VEHICLE_JOURNEYS':
      return [...action.json]
    default:
      return state
  }
}

module.exports = status
