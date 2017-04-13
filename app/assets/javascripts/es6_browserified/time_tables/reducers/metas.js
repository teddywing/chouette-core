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
    case 'UPDATE_DAY_TYPES':
      let dayTypes = state.day_types.slice(0)
      dayTypes[action.index] = !dayTypes[action.index]
      return _.assign({}, state, {day_types: dayTypes})
    default:
      return state
  }
}

module.exports = metas
