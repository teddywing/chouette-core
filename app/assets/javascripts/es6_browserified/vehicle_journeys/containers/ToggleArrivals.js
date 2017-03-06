var actions = require('../actions')
var connect = require('react-redux').connect
var ToggleArrivals = require('../components/ToggleArrivals')

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

const ToggleArrivalsList = connect(mapStateToProps, mapDispatchToProps)(ToggleArrivals)

module.exports = ToggleArrivalsList
