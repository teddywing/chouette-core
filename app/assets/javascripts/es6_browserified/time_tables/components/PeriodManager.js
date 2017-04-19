var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes

class PeriodManager extends Component {
  constructor(props) {
    super(props)
  }

  render() {
    return (
      <div>
        P
      </div>
    )
  }
}

PeriodManager.propTypes = {
  value: PropTypes.object.isRequired
}

module.exports = PeriodManager
