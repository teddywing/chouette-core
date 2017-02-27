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
        <div className='strong mb-xs'>{props.value.object_id}</div>
        <div>{props.value.registration_number}</div>
        <div>{actions.getChecked(props.value.stop_points).length}</div>

        <div className='clearfix' style={{display: 'inline-block', verticalAlign: 'top', width: '25px'}}>
          <button className={(props.value.deletable ? 'disabled' : '') + ' btn btn-xs btn-danger pull-right'} onClick={props.onOpenEditModal} data-toggle='modal' data-target='#JourneyPatternModal'>
            <span className='fa fa-pencil'></span>
          </button>
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
  onOpenEditModal: PropTypes.func.isRequired
}

module.exports = JourneyPattern
