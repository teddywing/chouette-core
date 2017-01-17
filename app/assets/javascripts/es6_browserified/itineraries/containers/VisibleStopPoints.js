var actions = require('../actions')
var connect = require('react-redux').connect
var StopPointList = require('../components/StopPointList')

const mapStateToProps = (state) => {
  return {
    stopPoints: state.stopPoints
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    onDeleteClick: (index) =>{
      dispatch(actions.deleteStop(index))
    },
    onMoveUpClick: (index) =>{
      dispatch(actions.moveStopUp(index))
    },
    onMoveDownClick: (index) =>{
      dispatch(actions.moveStopDown(index))
    },
    onChange: (index, text) =>{
      dispatch(actions.updateInputValue(index, text))
    },
    onSelectChange: (e, index) =>{
      dispatch(actions.updateSelectValue(e, index))
    }
  }
}

const VisibleStopPoints = connect(
  mapStateToProps,
  mapDispatchToProps
)(StopPointList)

module.exports = VisibleStopPoints
