var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes
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
  }
}

const JourneyPatternList = connect(mapStateToProps, mapDispatchToProps)(JourneyPatterns)

module.exports = JourneyPatternList
