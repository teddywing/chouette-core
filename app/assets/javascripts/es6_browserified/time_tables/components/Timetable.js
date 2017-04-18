var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes
var TimeTableDHead = require('./TimeTableDHead')
var TimeTableDBody = require('./TimeTableDBody')
var actions = require('../actions')

class Timetable extends Component{
  constructor(props){
    super(props)
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
              <div className="td">Journées d'application</div>
              <div className="td">Périodes</div>
              <div className="td">Exceptions</div>
            </div>
            <div className="t2e-item-list w80">
              <div>
                <div className="t2e-item">
                  <div className="th">
                    <div className="strong monthName">
                      {actions.monthName(this.props.timetable.current_periode_range)}
                    </div>

                    <div className='monthDays'>
                      {this.props.timetable.current_month.map((day, i) =>
                        <TimeTableDHead
                          key={i}
                          index={i}
                          value={day}
                          />
                      )}
                    </div>
                  </div>
                  {this.props.timetable.current_month.map((day, i) =>
                    <TimeTableDBody
                      key={i}
                      index={i}
                      value={day}
                      />
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
  timetable: PropTypes.object.isRequired,
}

module.exports = Timetable
