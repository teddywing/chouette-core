import _ from 'lodash'

export default function status(state = {}, action) {
  switch (action.type) {
    case 'UNAVAILABLE_SERVER':
      return _.assign({}, state, {fetchSuccess: false})
    case 'FETCH_API':
      return _.assign({}, state, {isFetching: true})
    case 'RECEIVE_TIME_TABLES':
    case 'RECEIVE_MONTH':
      return _.assign({}, state, {fetchSuccess: true, isFetching: false})
    default:
      return state
  }
}