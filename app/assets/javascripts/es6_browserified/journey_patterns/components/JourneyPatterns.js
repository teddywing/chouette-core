var React = require('react')
var PropTypes = require('react').PropTypes
var JourneyPattern = require('./JourneyPattern')

const JourneyPatterns = ({ journeyPatterns }) => {
  return (
    <div className='list-group'>
      {journeyPatterns.map((journeyPattern, index) =>
        <JourneyPattern
          value={ journeyPattern }
        />
      )}
    </div>
  )
}

JourneyPatterns.propTypes = {
  journeyPatterns: PropTypes.array.isRequired
}

module.exports = JourneyPatterns
