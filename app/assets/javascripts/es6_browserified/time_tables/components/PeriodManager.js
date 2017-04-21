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
        <p className='strong'>
          {actions.getHumanDate(this.props.value.period_start, 3).substr(0, 7) + ' > ' + actions.getHumanDate(this.props.value.period_end, 3)}
        </p>

        <div className='dropdown'>
          <div
            className='btn dropdown-toggle'
            id='period_actions'
            data-toggle='dropdown'
            aria-haspopup='true'
            aria-expanded='true'
          >
            <span className='fa fa-cog'></span>
          </div>
          <ul
            className='dropdown-menu'
            aria-labelledby='date_selector'
          >
            <li>
              <button
                type='button'
                onClick={() => this.props.onOpenEditPeriodForm(this.props.value)}
              >
                Modifier
              </button>
            </li>
            <li className='delete-action'>
              <button
                type='button'
                onClick={() => this.props.onDeletePeriod(this.props.index, this.props.metas.day_types)}
              >
                <span className='fa fa-trash'></span>
                Supprimer
              </button>
            </li>
          </ul>
        </div>
      </div>
    )
  }
}

PeriodManager.propTypes = {
  value: PropTypes.object.isRequired,
  onDeletePeriod: PropTypes.func.isRequired,
  onOpenEditPeriodForm: PropTypes.func.isRequired
}

module.exports = PeriodManager
