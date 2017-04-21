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
