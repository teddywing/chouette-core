var Component = require('react').Component
var React = require('react')
var PropTypes = require('react').PropTypes
var JourneyPattern = require('./JourneyPattern')


// const JourneyPatterns = ({journeyPatterns, onLoadFirstPage, onCheckboxChange}) => {
//   {onLoadFirstPage()}
//   return (
//     <div className='list-group'>
//       {journeyPatterns.map((journeyPattern, index) =>
//         <JourneyPattern
//           value={ journeyPattern }
//           key={ index }
//           onLoadFirstPage= {onLoadFirstPage()}
//           onCheckboxChange= {onCheckboxChange(index)}
//         />
//       )}
//     </div>
//   )
// }

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
          />
        )}
      </div>
    )
  }
}

JourneyPatterns.propTypes = {
  journeyPatterns: PropTypes.array.isRequired,
  onCheckboxChange: PropTypes.func.isRequired,
  onLoadFirstPage: PropTypes.func.isRequired
}

module.exports = JourneyPatterns
