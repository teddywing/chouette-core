var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes
var actions = require('../actions')

class PeriodManager extends Component {
  constructor(props) {
    super(props)
  }

  render() {
    return (
      <div
        className='period_manager'
        id={this.props.value.id}
      >
        <strong>{(this.props.value.period_start.split('-')[2]) + ' > ' + actions.getHumanDate(this.props.value.period_end, 3)}</strong>
      </div>
    )
  }
}

PeriodManager.propTypes = {
  value: PropTypes.object.isRequired
}

module.exports = PeriodManager
