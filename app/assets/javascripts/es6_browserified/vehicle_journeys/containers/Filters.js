var actions = require('../actions')
var connect = require('react-redux').connect
var Filters = require('../components/Filters')

const mapStateToProps = (state) => {
  return {
    filters: state.filters
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
    onResetFilters: () =>{
      dispatch(actions.resetFilters())
    },
    // onFilter: () =>{
    //   dispatch(actions.filterQuery())
    // },
    onSelect2Timetable: (e) => {
      dispatch(actions.filterSelect2Timetable(e.params.data))
    }
  }
}

const FiltersList = connect(mapStateToProps, mapDispatchToProps)(Filters)

module.exports = FiltersList
