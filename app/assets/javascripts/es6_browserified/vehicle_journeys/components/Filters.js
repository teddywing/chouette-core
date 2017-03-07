var React = require('react')
var PropTypes = require('react').PropTypes
var MissionSelect2 = require('./tools/select2s/MissionSelect2')
var TimetableSelect2 = require('./tools/select2s/TimetableSelect2')

const Filters = ({filters, onFilter, onResetFilters, onUpdateStartTimeFilter, onUpdateEndTimeFilter, onToggleWithoutSchedule, onSelect2Timetable}) => {
  return (
    <div className = 'form-filter mb-lg'>
      <div className = 'form-group'>
        <span><MissionSelect2 /></span>
      </div>
      <div className = 'form-group'>
        <span>Plage horaire au départ de la course </span>
        <span> Début </span>
        <input
          type='number'
          min='00'
          max='23'
          onChange={(e) => {onUpdateStartTimeFilter(e, 'hour')}}
          value={filters.query.interval.start.hour}
        />
        <input
          type='number'
          min='00'
          max='59'
          onChange={(e) => {onUpdateStartTimeFilter(e, 'minute')}}
          value={filters.query.interval.start.minute}
        />
        <span> Fin </span>
        <input
          type='number'
          min='00'
          max='23'
          onChange={(e) => {onUpdateEndTimeFilter(e, 'hour')}}
          value={filters.query.interval.end.hour}
        />
        <input
          type='number'
          min='00'
          max='59'
          onChange={(e) => {onUpdateEndTimeFilter(e, 'minute')}}
          value={filters.query.interval.end.minute}
        />
      </div>
      <div className = 'form-group'>
        <span>
          <TimetableSelect2
            onSelect2Timetable={onSelect2Timetable}
            hasRoute={true}
            chunkURL= {("/autocomplete_time_tables.json?route_id=" + String(window.route_id))}
          />
        </span>
      </div>
      <div className = 'form-group'>
        <span>Afficher les courses sans horaires</span>
        <input
          onChange = {onToggleWithoutSchedule}
          type = 'checkbox'
          checked = {filters.query.withoutSchedule}
        ></input>
      </div>
      <div className = 'actions'>
        <span
          className = 'btn btn-link'
          onClick = {onResetFilters}>
          EFFACER
        </span>
        <span
          className='btn btn-primary'
          onClick={onFilter}>
          FILTRER
        </span>
      </div>
    </div>
  )
}

Filters.propTypes = {
  filters : PropTypes.object.isRequired,
  onFilter: PropTypes.func.isRequired,
  onResetFilters: PropTypes.func.isRequired,
  onUpdateStartTimeFilter: PropTypes.func.isRequired,
  onUpdateEndTimeFilter: PropTypes.func.isRequired,
  onSelect2Timetable: PropTypes.func.isRequired
}

module.exports = Filters
