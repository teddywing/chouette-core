var _ = require('lodash')
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
      newQuery = _.assign({}, state.query, {interval: interval, journeyPattern: {}, timetable: {}, withoutSchedule: true })
      return _.assign({}, state, {query: newQuery, queryString: ''})
    case 'TOGGLE_WITHOUT_SCHEDULE':
      newQuery = _.assign({}, state.query, {withoutSchedule: !state.query.withoutSchedule})
      return _.assign({}, state, {query: newQuery})
    case 'UPDATE_END_TIME_FILTER':
      newInterval = JSON.parse(JSON.stringify(state.query.interval))
      newInterval.end[action.unit] = actions.pad(action.val, action.unit)
      if(parseInt(newInterval.start.hour + newInterval.start.minute) < parseInt(newInterval.end.hour + newInterval.end.minute)){
        newQuery = _.assign({}, state.query, {interval: newInterval})
        return _.assign({}, state, {query: newQuery})
      }else{
        return state
      }
    case 'UPDATE_START_TIME_FILTER':
      newInterval = JSON.parse(JSON.stringify(state.query.interval))
      newInterval.start[action.unit] = actions.pad(action.val, action.unit)
      if(parseInt(newInterval.start.hour + newInterval.start.minute) < parseInt(newInterval.end.hour + newInterval.end.minute)){
        newQuery = _.assign({}, state.query, {interval: newInterval})
        return _.assign({}, state, {query: newQuery})
      }else{
        return state
      }
    case 'SELECT_TT_FILTER':
      newQuery = _.assign({}, state.query, {timetable : action.selectedItem})
      return _.assign({}, state, {query: newQuery})
    case 'SELECT_JP_FILTER':
      newQuery = _.assign({}, state.query, {journeyPattern : action.selectedItem})
      return _.assign({}, state, {query: newQuery})
    case 'TOGGLE_ARRIVALS':
      return _.assign({}, state, {toggleArrivals: !state.toggleArrivals})
    case 'QUERY_FILTER_VEHICLEJOURNEYS':
      actions.fetchVehicleJourneys(action.dispatch, undefined, undefined, state.queryString)
      return state
    case 'CREATE_QUERY_STRING':
      let params = {
        'q[journey_pattern_id_eq]': state.query.journeyPattern.id || undefined,
        'q[time_tables_id_eq]': state.query.timetable.id || undefined,
        'q[vehicle_journey_at_stops_departure_time_gteq]': (state.query.interval.start.hour + ':' + state.query.interval.start.minute),
        'q[vehicle_journey_at_stops_departure_time_lteq]': (state.query.interval.end.hour + ':' + state.query.interval.end.minute),
        'q[vehicle_journey_without_u2]' : state.query.withoutSchedule
      }
      let queryString = actions.encodeParams(params)
      return _.assign({}, state, {queryString: queryString})
    default:
      return state
  }
}

module.exports = filters
