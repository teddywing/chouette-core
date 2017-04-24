const _ = require('lodash')
const actions = require('../actions')

const metas = (state = {}, action) => {
  switch (action.type) {
    case 'RECEIVE_TIME_TABLES':
      return _.assign({}, state, {
        comment: action.json.comment,
        day_types: actions.strToArrayDayTypes(action.json.day_types),
        tags: action.json.tags,
        color: action.json.color,
        calendar: action.json.calendar ? action.json.calendar : {name : 'Aucun'}
      })
    case 'UPDATE_DAY_TYPES':
      let dayTypes = state.day_types.slice(0)
      dayTypes[action.index] = !dayTypes[action.index]
      return _.assign({}, state, {day_types: dayTypes})
    case 'UPDATE_COMMENT':
      return _.assign({}, state, {comment: action.comment})
    case 'UPDATE_COLOR':
      return _.assign({}, state, {color: action.color})
    case 'UPDATE_SELECT_TAG':
      let tags = [...state.tags]
      tags.push(action.selectedItem)
      return _.assign({}, state, {tags: tags})
    case 'UPDATE_UNSELECT_TAG':
      return _.assign({}, state, {tags: _.filter(state.tags, (t) => (t.id != action.selectedItem.id))})
    default:
      return state
  }
}

module.exports = metas
