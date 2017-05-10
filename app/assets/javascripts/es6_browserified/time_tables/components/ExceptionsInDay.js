var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes
var actions = require('../actions')

class ExceptionsInDay extends Component {
  constructor(props) {
    super(props)
  }

  render() {
    {/* display add or remove link, only if true in daytypes */}
    if(this.props.outFromDaytypes == true) {
      {/* display add or remove link, according to context (presence in period, or not) */}
      if(this.props.value.current_month[this.props.index].in_periods == true) {
        return (
          <div className='td'>
            <button
              type='button'
              className={'btn btn-circle' + (this.props.value.current_month[this.props.index].excluded_date ? ' active' : '')}
              data-actiontype='remove'
              onClick={(e) => {
                $(e.currentTarget).toggleClass('active')
                this.props.onExcludeDateFromPeriod(this.props.index, this.props.metas.day_types)
              }}
            >
              <span className='fa fa-times'></span>
            </button>
          </div>
        )
      } else {
        return (
          <div className='td'>
            <button
              type='button'
              className={'btn btn-circle'  + (this.props.value.current_month[this.props.index].include_date ? ' active' : '')}
              data-actiontype='add'
              onClick={(e) => {
                $(e.currentTarget).toggleClass('active')
                this.props.onIncludeDateInPeriod(this.props.index, this.props.metas.day_types)
              }}
            >
              <span className='fa fa-plus'></span>
            </button>
          </div>
        )
      }
    } else {
      return (
        <div className='td'></div>
      )
    }
  }
}

ExceptionsInDay.propTypes = {
  value: PropTypes.object.isRequired,
  metas: PropTypes.object.isRequired,
  outFromDaytypes: PropTypes.bool.isRequired,
  onExcludeDateFromPeriod: PropTypes.func.isRequired,
  onIncludeDateInPeriod: PropTypes.func.isRequired,
  index: PropTypes.number.isRequired
}

module.exports = ExceptionsInDay
