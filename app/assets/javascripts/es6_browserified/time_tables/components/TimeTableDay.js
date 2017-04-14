var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes

class TimeTableDay extends Component {
  constructor(props) {
    super(props)
  }

  render() {
    return (
      <span className='day'>
        <span className='dayname'>
          {((this.props.value.day).charAt(0) == 'm') ? (this.props.value.day).substr(0, 2) : (this.props.value.day).charAt(0)}
        </span>
        <span className="daynumber">
          {this.props.value.mday}
        </span>
      </span>
    )
  }
}

TimeTableDay.propTypes = {
  value: PropTypes.object.isRequired,
  index: PropTypes.number.isRequired
}

module.exports = TimeTableDay
