const actions = {
  strToArrayDayTypes: (str) =>{
    let weekDays = ['Di', 'Lu', 'Ma', 'Me', 'Je', 'Ve', 'Sa']
    return weekDays.map((day, i) => str.indexOf(day) !== -1)
  },

  fetchingApi: () =>({
      type: 'FETCH_API'
  }),
  unavailableServer: () => ({
    type: 'UNAVAILABLE_SERVER'
  }),
  receiveTimeTables: (json) => ({
    type: 'RECEIVE_TIME_TABLES',
    json
  }),
  updateDayTypes: (index) => ({
    type: 'UPDATE_DAY_TYPES',
    index
  }),
  updateComment: (comment) => ({
    type: 'UPDATE_COMMENT',
    comment
  }),

  fetchTimeTables: (dispatch, currentPage, nextPage) => {
    let urlJSON = window.location.pathname.split('/', 5).join('/') + '.json'
    let hasError = false
    fetch(urlJSON, {
      credentials: 'same-origin',
    }).then(response => {
        if(response.status == 500) {
          hasError = true
        }
        return response.json()
      }).then((json) => {
        if(hasError == true) {
          dispatch(actions.unavailableServer())
        } else {
          dispatch(actions.receiveTimeTables(json))
        }
      })
  },
}

module.exports = actions
