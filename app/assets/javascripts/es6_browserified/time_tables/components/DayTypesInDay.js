var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes

class DayTypesInDay extends Component {
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

DayTypesInDay.propTypes = {
  value: PropTypes.object.isRequired,
  index: PropTypes.number.isRequired
}

module.exports = DayTypesInDay
