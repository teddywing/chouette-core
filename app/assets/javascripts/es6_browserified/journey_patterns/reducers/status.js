var actions = require("../actions")

const status = (state = {}, action) => {
  switch (action.type) {
    case 'UNAVAILABLE_SERVER':
      return Object.assign({}, state, {fetchSuccess: false})
    case 'RECEIVE_JOURNEY_PATTERNS':
      return Object.assign({}, state, {fetchSuccess: true})
    default:
      return state
  }
}

module.exports = status
