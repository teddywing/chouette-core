var actions = require('../actions')
var connect = require('react-redux').connect
var JourneyPatterns = require('../components/JourneyPatterns')

const mapStateToProps = (state) => {
  return {
    journeyPatterns: state.journeyPatterns
  }
}

const mapDispatchToProps = (dispatch) => {
  return {}
}

const JourneyPatternList = connect(
  mapStateToProps,
  mapDispatchToProps
)(JourneyPatterns)

module.exports = JourneyPatternList
