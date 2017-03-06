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
    onUpdateTimeFilter: (e, unit) =>{
      dispatch(actions.updateTimeFilter(e.target.value, unit))
    },
    onToggleWithoutSchedule: () =>{
      dispatch(actions.toggleWithoutSchedule())
    },
    onResetFilters: () =>{
      dispatch(actions.resetFilters())
    },
    onFilter: () =>{
      dispatch(actions.filterQuery())
    }
  }
}

const FiltersList = connect(mapStateToProps, mapDispatchToProps)(Filters)

module.exports = FiltersList
