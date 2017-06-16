var React = require('react')
var PropTypes = require('react').PropTypes
var MissionSelect2 = require('./tools/select2s/MissionSelect2')
var VJSelect2 = require('./tools/select2s/VJSelect2')
var TimetableSelect2 = require('./tools/select2s/TimetableSelect2')

const Filters = ({filters, pagination, onFilter, onResetFilters, onUpdateStartTimeFilter, onUpdateEndTimeFilter, onToggleWithoutSchedule, onToggleWithoutTimeTable, onSelect2Timetable, onSelect2JourneyPattern, onSelect2VehicleJourney}) => {
  return (
    <div className='row'>
      <div className='col-lg-12'>
        <div className='form form-filter'>
          <div className='ffg-row'>
            {/* ID course */}
            <div className="form-group w33">
              <VJSelect2
                onSelect2VehicleJourney={onSelect2VehicleJourney}
                filters={filters}
                isFilter={true}
                />
            </div>

            {/* Missions */}
            <div className='form-group w33'>
              <MissionSelect2
                onSelect2JourneyPattern={onSelect2JourneyPattern}
                filters={filters}
                isFilter={true}
                />
            </div>

            {/* Calendriers */}
            <div className='form-group w33'>
              <TimetableSelect2
                onSelect2Timetable={onSelect2Timetable}
                hasRoute={true}
                chunkURL={("/autocomplete_time_tables.json?route_id=" + String(window.route_id))}
                filters={filters}
                isFilter={true}
                />
            </div>
          </div>

          <div className='ffg-row'>
            {/* Plage horaire */}
            <div className='form-group togglable'>
              <label className='control-label'>Plage horaire au départ de la course</label>
              <div className='filter_menu'>
                <div className='form-group time filter_menu-item'>
                  <label className='control-label time'>Début</label>
                  <div className='form-inline'>
                    <div className='input-group time'>
                      <input
                        type='number'
                        className='form-control'
                        min='00'
                        max='23'
                        onChange={(e) => {onUpdateStartTimeFilter(e, 'hour')}}
                        value={filters.query.interval.start.hour}
                        />
                      <span>:</span>
                      <input
                        type='number'
                        className='form-control'
                        min='00'
                        max='59'
                        onChange={(e) => {onUpdateStartTimeFilter(e, 'minute')}}
                        value={filters.query.interval.start.minute}
                        />
                    </div>
                  </div>
                </div>
                <div className='form-group time filter_menu-item'>
                  <label className='control-label time'>Fin</label>
                  <div className='form-inline'>
                    <div className='input-group time'>
                      <input
                        type='number'
                        className='form-control'
                        min='00'
                        max='23'
                        onChange={(e) => {onUpdateEndTimeFilter(e, 'hour')}}
                        value={filters.query.interval.end.hour}
                        />
                      <span>:</span>
                      <input
                        type='number'
                        className='form-control'
                        min='00'
                        max='59'
                        onChange={(e) => {onUpdateEndTimeFilter(e, 'minute')}}
                        value={filters.query.interval.end.minute}
                        />
                    </div>
                  </div>
                </div>
              </div>
            </div>

            {/* Switch avec/sans horaires */}
            <div className='form-group has_switch'>
              <label className='control-label pull-left'>Afficher les courses sans horaires</label>
              <div className='form-group pull-left' style={{padding: 0}}>
                <div className='checkbox'>
                  <label>
                    <input
                      type='checkbox'
                      onChange={onToggleWithoutSchedule}
                      checked={filters.query.withoutSchedule}
                      ></input>
                    <span className='switch-label' data-checkedvalue='Non' data-uncheckedvalue='Oui'>
                      {filters.query.withoutSchedule ? 'Oui' : 'Non'}
                    </span>
                  </label>
                </div>
              </div>
            </div>
          </div>

          <div className="ffg-row">
            {/* Switch avec/sans calendrier */}
            <div className='form-group has_switch'>
              <label className='control-label pull-left'>Afficher les courses avec calendrier</label>
              <div className='form-group pull-left' style={{padding: 0}}>
                <div className='checkbox'>
                  <label>
                    <input
                      type='checkbox'
                      onChange={onToggleWithoutTimeTable}
                      checked={filters.query.withoutTimeTable}
                      ></input>
                    <span className='switch-label' data-checkedvalue='Non' data-uncheckedvalue='Oui'>
                      {filters.query.withoutTimeTable ? 'Oui' : 'Non'}
                    </span>
                  </label>
                </div>
              </div>
            </div>
          </div>

          {/* Actions */}
          <div className='actions'>
            <span
              className='btn btn-link'
              onClick={(e) => onResetFilters(e, pagination)}>
              Effacer
            </span>
            <span
              className='btn btn-default'
              onClick={(e) => onFilter(e, pagination)}>
              Filtrer
            </span>
          </div>
        </div>
      </div>
    </div>
  )
}

Filters.propTypes = {
  filters : PropTypes.object.isRequired,
  pagination : PropTypes.object.isRequired,
  onFilter: PropTypes.func.isRequired,
  onResetFilters: PropTypes.func.isRequired,
  onUpdateStartTimeFilter: PropTypes.func.isRequired,
  onUpdateEndTimeFilter: PropTypes.func.isRequired,
  onSelect2Timetable: PropTypes.func.isRequired,
  onSelect2JourneyPattern: PropTypes.func.isRequired,
  onSelect2VehicleJourney: PropTypes.func.isRequired
}

module.exports = Filters
