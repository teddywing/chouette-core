var React = require('react')
var PropTypes = require('react').PropTypes
var actions = require('../actions')

const JourneyPattern = (props) => {
  return (
    <div className={'t2e-item' + (props.value.deletable ? ' disabled' : '') + (props.value.object_id ? '' : ' to_record')}>
      {/* Errors */}
      {(props.value.errors) && (
        <ul className='alert alert-danger small' style={{paddingLeft: 30}}>
          {Object.keys(props.value.errors).map(function(key, i) {
            return (
              <li key={i} style={{listStyleType: 'disc'}}>
                <strong>'{key}'</strong> {props.value.errors[key]}
              </li>
            )
          })}
        </ul>
      )}

      <div className='th'>
        <div className='strong mb-xs'>{props.value.object_id ? props.value.object_id : '-'}</div>
        <div>{props.value.registration_number}</div>
        <div>{actions.getChecked(props.value.stop_points).length} arrêt(s)</div>

        <div className={props.value.deletable ? 'btn-group disabled' : 'btn-group'}>
          <div
            className={props.value.deletable ? 'btn dropdown-toggle disabled' : 'btn dropdown-toggle'}
            data-toggle='dropdown'
          >
            <span className='fa fa-cog'></span>
          </div>
          <ul className='dropdown-menu'>
            <li className={props.value.deletable ? 'disabled' : ''}>
              <a
                href='#'
                onClick={props.onOpenEditModal}
                data-toggle='modal'
                data-target='#JourneyPatternModal'
              >
                Modifier
              </a>
            </li>
            <li>
              <a href='#'>Horaires des courses</a>
            </li>
            <li className='delete-action'>
              <a
                href='#'
                onClick={(e) => {
                  e.preventDefault()
                  props.onDeleteJourneyPattern(props.index)}
                }
              >
                <span className='fa fa-trash'></span>Supprimer
              </a>
            </li>
          </ul>
        </div>
      </div>

      {props.value.stop_points.map((stopPoint, i) =>
        <div
          key={ i }
          className='td'
          >
          <span className='has_radio'>
            <input
              onChange = {(e) => props.onCheckboxChange(e)}
              type='checkbox'
              id={stopPoint.id}
              checked={stopPoint.checked}
              disabled={props.value.deletable ? 'disabled' : ''}
              >
            </input>
            <span className='radio-label'></span>
          </span>
        </div>
      )}
    </div>
  )
}

JourneyPattern.propTypes = {
  value: PropTypes.object,
  index: PropTypes.number,
  onCheckboxChange: PropTypes.func.isRequired,
  onOpenEditModal: PropTypes.func.isRequired,
  onDeleteJourneyPattern: PropTypes.func.isRequired
}

module.exports = JourneyPattern
