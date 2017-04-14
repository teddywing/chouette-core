var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes
var TimeTableDay = require('./TimeTableDay')

let monthList = ["Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"]

class Timetable extends Component{
  constructor(props){
    super(props)
  }

  monthName(strDate) {
    var date = new Date(strDate)
    return monthList[date.getMonth()]
  }

  render() {
    return (
      <div className='row'>
        <div className="col-lg-12">
          <div className="table table-2entries mt-sm mb-sm">
            <div className="t2e-head w20">
              <div className="th">
                <div></div>
                <div></div>
                <div></div>
                <div className="strong">Synthèse</div>
              </div>
              <div className="td">Journées d'application</div>
              <div className="td">Périodes</div>
              <div className="td">Exceptions</div>
            </div>
            <div className="t2e-item-list w80">
              <div className="t2e-item">
                <div className="th">
                  <div className="strong monthName">
                    {this.monthName(this.props.timetable.current_periode_range)}
                  </div>

                  <div className='monthDays'>
                    {this.props.timetable.current_month.map((day, i) =>
                      <TimeTableDay
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
      </div>
    )
  }
}

Timetable.propTypes = {
  timetable: PropTypes.object.isRequired,
}

module.exports = Timetable
