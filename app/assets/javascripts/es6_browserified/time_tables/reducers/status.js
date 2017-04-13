var _ = require('lodash')

const status = (state = {}, action) => {
  switch (action.type) {
    case 'UNAVAILABLE_SERVER':
      return _.assign({}, state, {fetchSuccess: false})
    case 'FETCH_API':
      return _.assign({}, state, {isFetching: true})
    case 'RECEIVE_TIME_TABLES':
      return _.assign({}, state, {fetchSuccess: true, isFetching: false})
    default:
      return state
  }
}

module.exports = status
