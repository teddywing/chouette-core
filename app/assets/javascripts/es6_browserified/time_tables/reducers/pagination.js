var _ = require('lodash')

const pagination = (state = {}, action) => {
  switch (action.type) {
    case 'RECEIVE_TIME_TABLES':
      return _.assign({}, state, {
        currentPage: action.json.current_periode_range,
        periode_range: action.json.periode_range
      })
    case 'GO_TO_PREVIOUS_PAGE':
    case 'GO_TO_NEXT_PAGE':
      let nextPage = action.nextPage ? 1 : -1
      let newPage = action.pagination.periode_range[action.pagination.periode_range.indexOf(action.pagination.currentPage) + nextPage]
      toggleOnConfirmModal()
      return _.assign({}, state, {currentPage : newPage, stateChanged: false})
    default:
      return state
  }
}

const toggleOnConfirmModal = (arg = '') =>{
  $('.confirm').each(function(){
    $(this).data('toggle','')
  })
}

module.exports = pagination
