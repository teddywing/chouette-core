const actions = require('../actions')

const dayTypes = (state = "", action) => {
  switch (action.type) {
    case 'RECEIVE_TIME_TABLES':
      return actions.strToArrayDayTypes(action.json.day_types)
    default:
      return state
  }
}

module.exports = dayTypes
