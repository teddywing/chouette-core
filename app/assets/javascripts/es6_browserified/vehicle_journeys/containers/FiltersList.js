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
    onToggleArrivals: () =>{
      dispatch(actions.toggleArrivals())
    }
  }
}

const FiltersList = connect(mapStateToProps, mapDispatchToProps)(Filters)

module.exports = FiltersList
