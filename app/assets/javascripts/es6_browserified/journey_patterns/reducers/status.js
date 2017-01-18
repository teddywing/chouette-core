var actions = require("../actions")

const status = (state = {}, action) => {
  switch (action.type) {
    case 'UNAVAILABLE_SERVER':
      return Object.assign({}, state, {fetchSuccess: false})
    case 'FETCH_API':
      return Object.assign({}, state, {isFetching: true})
    case 'RECEIVE_JOURNEY_PATTERNS':
      return Object.assign({}, state, {fetchSuccess: true, isFetching: false})
    default:
      return state
  }
}

module.exports = status
