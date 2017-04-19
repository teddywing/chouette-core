const _ = require('lodash')

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
  receiveMonth: (json) => ({
    type: 'RECEIVE_MONTH',
    json
  }),
  receiveTimeTables: (json) => ({
    type: 'RECEIVE_TIME_TABLES',
    json
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
  changePage : (dispatch, pagination, val) => ({
    type: 'CHANGE_PAGE',
    dispatch,
    page: val
  }),
  updateDayTypes: (index) => ({
    type: 'UPDATE_DAY_TYPES',
    index
  }),
  updateComment: (comment) => ({
    type: 'UPDATE_COMMENT',
    comment
  }),
  updateColor: (color) => ({
    type: 'UPDATE_COLOR',
    color
  }),
  select2Tags: (selectedTag) => ({
    type: 'UPDATE_SELECT_TAG',
    selectedItem: {
      id: selectedTag.id,
      name: selectedTag.name
    }
  }),
  unselect2Tags: (selectedTag) => ({
    type: 'UPDATE_UNSELECT_TAG',
    selectedItem: {
      id: selectedTag.id,
      name: selectedTag.name
    }
  }),
  monthName(strDate) {
    let monthList = ["Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"]
    var date = new Date(strDate)
    return monthList[date.getMonth()]
  },

  updateSynthesis: (state, daytypes) => {
    let periods = state.time_table_periods

    let isInPeriod = function(d){
      let currentMonth = state.current_periode_range.split('-')
      let twodigitsDay = d.mday < 10 ? ('0' + d.mday) : d.mday
      let currentDate = new Date(currentMonth[0] + '-' + currentMonth[1] + '-' + twodigitsDay)

      // We compare periods & currentDate, to determine if it is included or not
      let testDate = false
      periods.map((p, i) => {
        let begin = new Date(p.period_start)
        let end = new Date(p.period_end)

        if(testDate === false){
          if(currentDate >= begin && currentDate <= end) {
            if(d.excluded_date) {
              testDate = false
            } else if(daytypes[d.wday] === false) {
              testDate = false
            } else {
              testDate = true
            }
          } else {
            if(d.include_date) {
              testDate = true
            } else {
              testDate = false
            }
          }
        }
      })
      return testDate
    }

    let improvedCM = state.current_month.map((d, i) => {
      return _.assign({}, state.current_month[i], {
        in_periods: isInPeriod(state.current_month[i])
      })
    })
    return improvedCM
  },

  checkConfirmModal : (event, callback, stateChanged,dispatch) => {
    if(stateChanged === true){
      return actions.openConfirmModal(callback)
    }else{
      dispatch(actions.fetchingApi())
      return callback
    }
  },
  fetchTimeTables: (dispatch, nextPage) => {
    let urlJSON = window.location.pathname.split('/', 5).join('/')
    // console.log(nextPage)
    if(nextPage) {
      urlJSON += "/month.json?date=" + nextPage
    }else{
      urlJSON += ".json"
    }
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
          if(nextPage){
            dispatch(actions.receiveMonth(json))
          }else{
            dispatch(actions.receiveTimeTables(json))
          }
        }
      })
  },
}

module.exports = actions
