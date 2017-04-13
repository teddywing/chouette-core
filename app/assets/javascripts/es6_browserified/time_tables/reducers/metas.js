const _ = require('lodash')
const actions = require('../actions')

const metas = (state = {}, action) => {
  switch (action.type) {
    case 'RECEIVE_TIME_TABLES':
      return _.assign({}, state, {
        comment: action.json.comment,
        day_types: actions.strToArrayDayTypes(action.json.day_types),
        tags: action.json.tags,
        color: action.json.color
      })
    default:
      return state
  }
}

module.exports = metas
