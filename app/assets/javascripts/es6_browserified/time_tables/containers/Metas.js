var actions = require('../actions')
var connect = require('react-redux').connect
var MetasComponent = require('../components/Metas')

const mapStateToProps = (state) => {
  return {
    day_types: state.day_types
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
  }
}

const Metas = connect(mapStateToProps, mapDispatchToProps)(MetasComponent)

module.exports = Metas
