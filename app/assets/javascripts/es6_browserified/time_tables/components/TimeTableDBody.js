var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes

class TimeTableDBody extends Component {
  constructor(props) {
    super(props)
  }

  render() {
    return (
      <div>
        toto
      </div>
    )
  }
}

TimeTableDBody.propTypes = {
  value: PropTypes.object.isRequired,
  index: PropTypes.number.isRequired
}

module.exports = TimeTableDBody
