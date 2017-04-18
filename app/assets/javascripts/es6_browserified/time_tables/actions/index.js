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

  updateSynthesis: (state) => {
    let periods = state.time_table_periods

    let isInPeriod = function(data){
      let currentMonth = state.current_periode_range.split('-')
      let currentDate = new Date(currentMonth[0] + '-' + currentMonth[1] + '-' + data.mday)

      // Exception wins anyway
      if(data.excluded_date) {
        return false
      } else if(data.include_date) {
        return true
      } else {
        // We compare periods & currentdate, to determine if it is included or not
        let testDate = false
        periods.map((p, i) => {
          let begin = new Date(p.period_start)
          let end = new Date(p.period_end)

          if(currentDate >= begin && currentDate <= end) {
            testDate = true
          }
        })
        return testDate
      }
    }

    let improvedCM = state.current_month.map((d, i) => {
      return _.assign({}, state.current_month[i], {
        in_periods: isInPeriod(state.current_month[i])
      })
    })
    return improvedCM
  },

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
