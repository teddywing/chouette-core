const _ = require('lodash')
const actions = require('../actions')

const metas = (state = {}, action) => {
  switch (action.type) {
    case 'RECEIVE_TIME_TABLES':
      return _.assign({}, state, {
        comment: action.json.comment,
        day_types: actions.strToArrayDayTypes(action.json.day_types),
        tags: action.json.tags,
        initial_tags: action.json.tags,
        color: action.json.color,
        calendar: action.json.calendar ? action.json.calendar : null
      })
    case 'INCLUDE_DATE_IN_PERIOD':
    case 'EXCLUDE_DATE_FROM_PERIOD':
    case 'DELETE_PERIOD':
    case 'VALIDATE_PERIOD_FORM':
      return _.assign({}, state, {calendar: null})
    case 'UPDATE_DAY_TYPES':
      return _.assign({}, state, {day_types: action.dayTypes, calendar : null})
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
