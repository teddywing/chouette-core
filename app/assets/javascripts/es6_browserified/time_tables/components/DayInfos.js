var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes

class DayInfos extends Component {
  constructor(props) {
    super(props)
  }

  render() {
    return (
      <div className='td-group'>
        <div className="td">A</div>
        <div className="td">B</div>
        <div className="td">C</div>
      </div>
    )
  }
}

DayInfos.propTypes = {
  value: PropTypes.object.isRequired,
  index: PropTypes.number.isRequired
}

module.exports = DayInfos
