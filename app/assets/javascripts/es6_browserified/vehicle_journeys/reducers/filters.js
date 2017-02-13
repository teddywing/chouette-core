var actions = require("../actions")

const filters = (state = {}, action) => {
  switch (action.type) {
    case 'TOGGLE_ARRIVALS':
      return Object.assign({}, state, {toggleArrivals: !state.toggleArrivals})
    default:
      return state
  }
}

module.exports = filters
