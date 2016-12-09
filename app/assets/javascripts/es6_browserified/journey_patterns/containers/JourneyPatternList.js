var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes
var actions = require('../actions')
var connect = require('react-redux').connect
var JourneyPattern = require('../components/JourneyPattern')

class JourneyPatternList extends Component{
  constructor(props) {
    super(props)
  }

  componentDidMount() {
    const dispatch = this.props.dispatch
    const journeyPatterns = this.props.journeyPatterns
    actions.fetchJourneyPatterns(dispatch)
  }

  render() {
    return (
      <div className='list-group'>
        {this.props.journeyPatterns.map((journeyPattern, index) =>
          <JourneyPattern
            value={ journeyPattern }
            key={ index }
          />
        )}
      </div>
    )
  }
}

const mapStateToProps = (state) => {
  return {
    journeyPatterns: state.journeyPatterns
  }
}

JourneyPatternList.propTypes = {
  dispatch: PropTypes.func.isRequired,
  journeyPatterns: PropTypes.array.isRequired
}

JourneyPatternList = connect(mapStateToProps)(JourneyPatternList)

module.exports = JourneyPatternList
