var _ = require('lodash')

const pagination = (state = {}, action) => {
  switch (action.type) {
      case 'RECEIVE_TIME_TABLES':
        return _.assign({}, state, {
          currentPage: action.json.current_periode_range,
          periode_range: action.json.periode_range
        })
    default:
      return state
  }
}

module.exports = pagination
