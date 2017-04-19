var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes

class ExceptionsInDay extends Component {
  constructor(props) {
    super(props)
  }

  render() {
    return (
      <div className="td">
      </div>
    )
  }
}

ExceptionsInDay.propTypes = {
  value: PropTypes.object.isRequired,
  index: PropTypes.number.isRequired
}

module.exports = ExceptionsInDay
