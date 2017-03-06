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
    onFilters: () =>{
      dispatch(actions.toggleArrivals())
    }
  }
}

const FiltersList = connect(mapStateToProps, mapDispatchToProps)(Filters)

module.exports = FiltersList
