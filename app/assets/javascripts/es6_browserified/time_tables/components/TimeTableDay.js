var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes

class TimeTableDay extends Component {
  constructor(props) {
    super(props)
  }

  render() {
    return (
      <div className='t2e-item'>
        Toto
      </div>
    )
  }
}

TimeTableDay.propTypes = {
  value: PropTypes.object.isRequired,
  index: PropTypes.number.isRequired
}

module.exports = TimeTableDay
