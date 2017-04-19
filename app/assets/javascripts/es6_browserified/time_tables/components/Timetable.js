var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes
var TimeTableDay = require('./TimeTableDay')
var DayTypesInDay = require('./DayTypesInDay')
var actions = require('../actions')

class Timetable extends Component{
  constructor(props){
    super(props)
  }

  componentDidUpdate(prevProps, prevState) {
    if(this.props.status.isFetching == false){
      $('.table-2entries').each(function() {
        var refH = []
        var refCol = []

        $(this).find('.t2e-head').children('.td').each(function() {
          var h = $(this).outerHeight();
          refH.push(h)
        });

        $(this).find('.t2e-item').children('.td-group').each(function() {
          for(var nth = 0; nth < refH.length; nth++) {
            $(this).find('.td:nth-child('+ (nth + 1) +')').css('height', refH[nth]);
          }
        });
      });
    }
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
                      {this.props.timetable.current_month.map((d, i) =>
                        <TimeTableDay
                          key={i}
                          index={i}
                          value={d}
                          />
                      )}
                    </div>
                  </div>

                  {this.props.timetable.current_month.map((d, i) =>
                    <div
                      key={i}
                      className={'td-group' + (this.props.metas.day_types[d.wday] ? '' : ' out_from_daytypes') + (d.wday == 0 ? ' last_wday' : '')}
                    >
                      <DayTypesInDay
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
  status: PropTypes.object.isRequired
}

module.exports = Timetable
