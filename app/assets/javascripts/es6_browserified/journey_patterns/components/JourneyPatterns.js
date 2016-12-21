var Component = require('react').Component
var React = require('react')
var PropTypes = require('react').PropTypes
var JourneyPattern = require('./JourneyPattern')

class JourneyPatterns extends Component{

  constructor(props){
    super(props)
  }

  componentDidMount() {
    this.props.onLoadFirstPage()
  }

  render() {
    return (
      <div className='list-group'>
        {this.props.journeyPatterns.map((journeyPattern, index) =>
          <JourneyPattern
            value={ journeyPattern }
            key={ index }
            onCheckboxChange= {(e) => this.props.onCheckboxChange(e, index)}
            onUpdateModalOpen= {() => this.props.onUpdateModalOpen(index, journeyPattern)}
          />
        )}
      </div>
    )
  }
}

JourneyPatterns.propTypes = {
  journeyPatterns: PropTypes.array.isRequired,
  onCheckboxChange: PropTypes.func.isRequired,
  onLoadFirstPage: PropTypes.func.isRequired,
  onUpdateModalOpen: PropTypes.func.isRequired
}

module.exports = JourneyPatterns
