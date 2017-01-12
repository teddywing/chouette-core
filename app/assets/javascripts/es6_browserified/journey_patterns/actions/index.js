const actions = {
  receiveJourneyPatterns : (json) => ({
    type: "RECEIVE_JOURNEY_PATTERNS",
    json
  }),
  receiveErrors : (json) => ({
    type: "RECEIVE_ERRORS",
    json
  }),
  unavailableServer : () => ({
    type: 'UNAVAILABLE_SERVER'
  }),
  goToPreviousPage : (dispatch, pagination) => ({
    type: 'GO_TO_PREVIOUS_PAGE',
    dispatch,
    pagination,
    nextPage : false
  }),
  goToNextPage : (dispatch, pagination) => ({
    type: 'GO_TO_NEXT_PAGE',
    dispatch,
    pagination,
    nextPage : true
  }),
  updateCheckboxValue : (e, index) => ({
    type : 'UPDATE_CHECKBOX_VALUE',
    id : e.currentTarget.id,
    index
  }),
  checkConfirmModal : (event, callback, stateChanged) => {
    if(stateChanged === true){
      return actions.openConfirmModal(callback)
    }else{
      return callback
    }
  },
  openConfirmModal : (callback) => ({
    type : 'OPEN_CONFIRM_MODAL',
    callback
  }),
  openEditModal : (index, journeyPattern) => ({
    type : 'EDIT_JOURNEYPATTERN_MODAL',
    index,
    journeyPattern
  }),
  openCreateModal : () => ({
    type : 'CREATE_JOURNEYPATTERN_MODAL'
  }),
  deleteJourneyPattern : (index) => ({
    type : 'DELETE_JOURNEYPATTERN',
    index,
  }),
  closeModal : () => ({
    type : 'CLOSE_MODAL'
  }),
  saveModal : (index, data) => ({
    type: 'SAVE_MODAL',
    data,
    index
  }),
  addJourneyPattern : (data) => ({
    type: 'ADD_JOURNEYPATTERN',
    data,
  }),
  savePage : (dispatch, currentPage) => ({
    type: 'SAVE_PAGE',
    dispatch
  }),
  updateTotalCount: (diff) => ({
    type: 'UPDATE_TOTAL_COUNT',
    diff
  }),
  resetValidation: (target) => {
    $(target).parent().removeClass('has-error').children('.help-block').remove()
  },
  validateFields : (fields) => {
    const test = []

    Object.keys(fields).map(function(key) {
      test.push(fields[key].validity.valid)
    })
    if(test.indexOf(false) >= 0) {
      // Form is invalid
      test.map(function(item, i) {
        if(item == false) {
          const k = Object.keys(fields)[i]
          $(fields[k]).parent().addClass('has-error').children('.help-block').remove()
          $(fields[k]).parent().append("<span class='small help-block'>" + fields[k].validationMessage + "</span>")
        }
      })
      return false
    } else {
      // Form is valid
      return true
    }
  },
  submitJourneyPattern : (dispatch, state, next) => {
    let urlJSON = window.location.pathname + ".json"
    let req = new Request(urlJSON, {
      credentials: 'same-origin',
      method: 'PATCH',
      contentType: 'application/json; charset=utf-8',
      Accept: 'application/json',
      body: JSON.stringify(state),
      headers: {
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
      }
    })
    let hasError = false
    fetch(req)
      .then(response => {
        if(!response.ok) {
          hasError = true
        }
        return response.json()
      }).then((json) => {
        if(hasError == true) {
          dispatch(actions.receiveErrors(json))
        } else {
          if(next) {
            dispatch(next)
          } else {
            dispatch(actions.receiveJourneyPatterns(json))
          }
        }
      })
  },
  fetchJourneyPatterns : (dispatch, currentPage, nextPage) => {
    if(currentPage == undefined){
      currentPage = 1
    }
    let journeyPatterns = []
    let page
    switch (nextPage) {
      case true:
        page = currentPage + 1
        break
      case false:
        if(currentPage > 1){
          page = currentPage - 1
        }
        break
      default:
        page = currentPage
        break
    }
    let str = ".json"
    if(page > 1){
      str = '.json?page=' + page.toString()
    }
    let urlJSON = window.location.pathname + str
    let req = new Request(urlJSON, {
      credentials: 'same-origin',
    })
    let hasError = false
    fetch(req)
      .then(response => {
        if(response.status == 500) {
          hasError = true
        }
        return response.json()
      }).then((json) => {
        if(hasError == true) {
          dispatch(actions.unavailableServer())
        } else {
          let val
          for (val of json){
            for (let stop_point of val.route_short_description.stop_points){
              stop_point.checked = false
              val.stop_area_short_descriptions.map((element) => {
                if(element.stop_area_short_description.id === stop_point.id){
                  stop_point.checked = true
                }
              })
            }
            journeyPatterns.push({
              name: val.name,
              object_id: val.object_id,
              published_name: val.published_name,
              registration_number: val.registration_number,
              stop_points: val.route_short_description.stop_points,
              deletable: false
            })
          }
          if(journeyPatterns.length != window.journeyPatternsPerPage){
            dispatch(actions.updateTotalCount(journeyPatterns.length - window.journeyPatternsPerPage))
          }
          dispatch(actions.receiveJourneyPatterns(journeyPatterns))
        }
      })
  }
}

module.exports = actions
