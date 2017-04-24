var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes
var PeriodManager = require('./PeriodManager')

class PeriodsInDay extends Component {
  constructor(props) {
    super(props)
  }

  isIn(date) {
    let currentDate = date.getTime()
    let cls = 'td'
    let periods = this.props.value

    periods.map((p, i) => {
      if (!p.deleted){
        let begin = new Date(p.period_start).getTime()
        let end = new Date(p.period_end).getTime()

        if(currentDate >= begin && currentDate <= end) {
          if(currentDate == begin) {
            cls += ' in_periods start_period'
          } else if(currentDate == end) {
            cls += ' in_periods end_period'
          } else {
            cls += ' in_periods'
          }
        }
      }
    })
    return cls
  }

  render() {
    return (
      <div
        className={this.isIn(this.props.currentDate)}
      >
        {this.props.value.map((p, i) => {
          if(!p.deleted){
            let begin = new Date(p.period_start).getTime()
            let end = new Date(p.period_end).getTime()
            let d = this.props.currentDate.getTime()

            if(d >= begin && d <= end) {
              if(d == begin || (this.props.currentDate.getUTCDate() == 1)) {
                return (
                  <PeriodManager
                    key={i}
                    index={i}
                    value={p}
                    onDeletePeriod={this.props.onDeletePeriod}
                    onOpenEditPeriodForm={this.props.onOpenEditPeriodForm}
                    metas={this.props.metas}
                  />
                )
              } else {
                return false
              }
            }
          }else{
            return false
          }
        })}
      </div>
    )
  }
}

PeriodsInDay.propTypes = {
  value: PropTypes.array.isRequired,
  currentDate: PropTypes.object.isRequired,
  index: PropTypes.number.isRequired,
  onDeletePeriod: PropTypes.func.isRequired
}

module.exports = PeriodsInDay
