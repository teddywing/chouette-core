var _ = require('lodash')
let newModalProps = {}

const modal = (state = {}, action) => {
  switch (action.type) {
    case 'CLOSE_PERIOD_FORM':
      let emptyDate = {
        begin: '',
        month: '',
        year: ''
      }
      newModalProps = _.assign({}, state.modalProps, {active: false, begin: emptyDate, end: emptyDate})
      return _.assign({}, state, {modalProps: newModalProps})
    case 'OPEN_EDIT_PERIOD_FORM':
      let period_start = action.period.period_start.split('-')
      let period_end = action.period.period_end.split('-')
      newModalProps = JSON.parse(JSON.stringify(state.modalProps))

      newModalProps.begin.year = period_start[0]
      newModalProps.begin.month = period_start[1]
      newModalProps.begin.day = period_start[2]

      newModalProps.end.year = period_end[0]
      newModalProps.end.month = period_end[1]
      newModalProps.end.day = period_end[2]

      newModalProps.active = true
      return _.assign({}, state, {modalProps: newModalProps})
    case 'OPEN_ADD_PERIOD_FORM':
      newModalProps = _.assign({}, state.modalProps, {active: true})
      return _.assign({}, state, {modalProps: newModalProps})
    case 'UPDATE_PERIOD_FORM':
      newModalProps = JSON.parse(JSON.stringify(state.modalProps))
      newModalProps[action.group][action.selectType] = action.val
      return _.assign({}, state, {modalProps: newModalProps})
    default:
      return state
  }
}

module.exports = modal
