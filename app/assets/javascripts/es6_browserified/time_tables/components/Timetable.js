var React = require('react')
var PropTypes = require('react').PropTypes

const Timetable = ({current_month, time_table_periods}) => {
  return (
    <div>
      <h2>Calendrier</h2>
      <ul>
        {current_month.map((day, i) =>
          <li
            key={i}
          >
            <span>{day.day} {day.mday} ({day.wday} {day.included_date} {day.excluded_date})</span>
          </li>
        )}
      </ul>
    </div>
  )
}

Timetable.propTypes = {
  current_month: PropTypes.array.isRequired,
  time_table_periods: PropTypes.array.isRequired
}

module.exports = Timetable
