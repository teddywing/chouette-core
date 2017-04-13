var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes
var TimeTableDay = require('./TimeTableDay')

class Timetable extends Component{
  constructor(props){
    super(props)
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
    )
  }
}

Timetable.propTypes = {
  timetable: PropTypes.object.isRequired,
}

module.exports = Timetable
