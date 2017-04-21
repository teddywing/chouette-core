var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes
var TimeTableDay = require('./TimeTableDay')
var PeriodsInDay = require('./PeriodsInDay')
var ExceptionsInDay = require('./ExceptionsInDay')
var actions = require('../actions')

class Timetable extends Component{
  constructor(props){
    super(props)
  }

  currentDate(mFirstday, day) {
    let currentMonth = mFirstday.split('-')
    let twodigitsDay = day < 10 ? ('0' + day) : day
    let currentDate = new Date(currentMonth[0] + '-' + currentMonth[1] + '-' + twodigitsDay)

    return currentDate
  }

  render() {
    return (
      <div className='row'>
        <div className="col-lg-8 col-lg-offset-2 col-md-8 col-md-offset-2 col-sm-10 col-sm-offset-1">
          <div className="table table-2entries mb-sm">
            <div className="t2e-head w20">
              <div className="th">
                <div className="strong">Synthèse</div>
              </div>
              <div className="td"><span>Journées d'application</span></div>
              <div className="td"><span>Périodes</span></div>
              <div className="td"><span>Exceptions</span></div>
            </div>
            <div className="t2e-item-list w80">
              <div>
                <div className="t2e-item">
                  <div className="th">
                    <div className="strong monthName">
                      {actions.monthName(this.props.timetable.current_periode_range)}
                    </div>

                    <div className='monthDays'>
                      {this.props.timetable.current_month.map((d, i) =>
                        <TimeTableDay
                          key={i}
                          index={i}
                          value={d}
                          dayTypeActive={this.props.metas.day_types[d.wday]}
                          />
                      )}
                    </div>
                  </div>

                  {this.props.timetable.current_month.map((d, i) =>
                    <div
                      key={i}
                      className={'td-group' + (this.props.metas.day_types[d.wday] ? '' : ' out_from_daytypes') + (d.wday == 0 ? ' last_wday' : '')}
                    >
                      {/* day_types */}
                      <div className="td"></div>

                      {/* periods */}
                      <PeriodsInDay
                        index={i}
                        value={this.props.timetable.time_table_periods}
                        currentDate={this.currentDate(this.props.timetable.current_periode_range, d.mday)}
                        onDeletePeriod={this.props.onDeletePeriod}
                        metas={this.props.metas}
                      />

                      {/* exceptions */}
                      <ExceptionsInDay
                        index={i}
                        value={this.props.timetable}
                      />
                    </div>
                  )}
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  }
}

Timetable.propTypes = {
  metas: PropTypes.object.isRequired,
  timetable: PropTypes.object.isRequired,
  status: PropTypes.object.isRequired,
  onDeletePeriod: PropTypes.func.isRequired
}

module.exports = Timetable
