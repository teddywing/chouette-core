var React = require('react')
var PropTypes = require('react').PropTypes

const Timetable = ({timetable}) => {
  return (
    <div>
      <h2>Calendrier</h2>
      <ul>
        {timetable.current_month.map((day, i) =>
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
  timetable: PropTypes.object.isRequired,
}

module.exports = Timetable
