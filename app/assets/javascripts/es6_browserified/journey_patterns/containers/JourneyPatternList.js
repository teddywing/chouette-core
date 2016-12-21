var actions = require('../actions')
var connect = require('react-redux').connect
var JourneyPatterns = require('../components/JourneyPatterns')

const mapStateToProps = (state) => {
  return {
    journeyPatterns: state.journeyPatterns
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    onLoadFirstPage: () =>{
      dispatch(actions.loadFirstPage(dispatch))
    },
    onCheckboxChange: (e, index) =>{
      dispatch(actions.updateCheckboxValue(e, index))
    },
    onUpdateModalOpen: (index, journeyPattern) =>{
      dispatch(actions.openUpdateModalOpen(index, journeyPattern))
    }
  }
}

const JourneyPatternList = connect(mapStateToProps, mapDispatchToProps)(JourneyPatterns)

module.exports = JourneyPatternList
