var actions = require('../actions')
var connect = require('react-redux').connect
var MetasComponent = require('../components/Metas')

const mapStateToProps = (state) => {
  return {
    metas: state.metas
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    onUpdateDayTypes: (index) => {
      dispatch(actions.updateDayTypes(index))
    }
  }
}

const Metas = connect(mapStateToProps, mapDispatchToProps)(MetasComponent)

module.exports = Metas
