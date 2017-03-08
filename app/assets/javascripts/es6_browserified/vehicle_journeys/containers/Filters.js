var actions = require('../actions')
var connect = require('react-redux').connect
var Filters = require('../components/Filters')

const mapStateToProps = (state) => {
  return {
    filters: state.filters,
    pagination: state.pagination
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    onUpdateStartTimeFilter: (e, unit) =>{
      e.preventDefault()
      dispatch(actions.updateStartTimeFilter(e.target.value, unit))
    },
    onUpdateEndTimeFilter: (e, unit) =>{
      e.preventDefault()
      dispatch(actions.updateEndTimeFilter(e.target.value, unit))
    },
    onToggleWithoutSchedule: () =>{
      dispatch(actions.toggleWithoutSchedule())
    },
    onResetFilters: (e, pagination) =>{
      dispatch(actions.checkConfirmModal(e, actions.resetFilters(dispatch), pagination.stateChanged, dispatch))
    },
    onFilter: (e, pagination) =>{
      dispatch(actions.checkConfirmModal(e, actions.filterQuery(dispatch), pagination.stateChanged, dispatch))
    },
    onSelect2Timetable: (e) => {
      dispatch(actions.filterSelect2Timetable(e.params.data))
    },
    onSelect2JourneyPattern: (e) => {
      dispatch(actions.filterSelect2JourneyPattern(e.params.data))
    }
  }
}

const FiltersList = connect(mapStateToProps, mapDispatchToProps)(Filters)

module.exports = FiltersList
