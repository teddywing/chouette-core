var actions = require("../actions")
let newQuery, newInterval

const filters = (state = {}, action) => {
  switch (action.type) {
    case 'RESET_FILTERS':
      let interval = {
        start:{
          hour: '00',
          minute: '00'
        },
        end:{
          hour: '23',
          minute: '59'
        }
      }
      newQuery = Object.assign({}, state.query, {interval: interval, journeyPattern: {}, timetable: {}, withoutSchedule: false })
      return Object.assign({}, state, {query: newQuery})
    case 'TOGGLE_WITHOUT_SCHEDULE':
      newQuery = Object.assign({}, state.query, {withoutSchedule: !state.query.withoutSchedule})
      return Object.assign({}, state, {query: newQuery})
    case 'UPDATE_END_TIME_FILTER':
      newInterval = JSON.parse(JSON.stringify(state.query.interval))
      newInterval.end[action.unit] = actions.pad(action.val)
      if(parseInt(newInterval.start.hour + newInterval.start.minute) < parseInt(newInterval.end.hour + newInterval.end.minute)){
        newQuery = Object.assign({}, state.query, {interval: newInterval})
        return Object.assign({}, state, {query: newQuery})
      }else{
        return state
      }
    case 'UPDATE_START_TIME_FILTER':
      newInterval = JSON.parse(JSON.stringify(state.query.interval))
      newInterval.start[action.unit] = actions.pad(action.val)
      if(parseInt(newInterval.start.hour + newInterval.start.minute) < parseInt(newInterval.end.hour + newInterval.end.minute)){
        newQuery = Object.assign({}, state.query, {interval: newInterval})
        return Object.assign({}, state, {query: newQuery})
      }else{
        return state
      }
    case 'SELECT_TT_FILTER':
      newQuery = Object.assign({}, state.query, {timetable : action.selectedItem})
      return Object.assign({}, state, {query: newQuery})
    case 'TOGGLE_ARRIVALS':
      return Object.assign({}, state, {toggleArrivals: !state.toggleArrivals})
    default:
      return state
  }
}

module.exports = filters
