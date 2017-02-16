var React = require('react')
var PropTypes = require('react').PropTypes

const JourneyPattern = (props) => {
  return (
    <div className={'list-group-item ' + (props.value.deletable ? 'disabled' : '') + (props.value.object_id ? '' : 'to_record')}>
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

      <div style={{display: 'inline-block', verticalAlign: 'top', width: 'calc(100% - 25px)'}}>
        {/* Name */}
        <p className='small'>
          <strong>Name: </strong>{props.value.name}
        </p>

        {/* Published name */}
        <p className='small'>
          <strong>Published name: </strong>{props.value.comment}
        </p>

        {/* Registration number */}
        <p className='small'>
          <strong>Registration number: </strong>{props.value.registration_number}
        </p>

        {/* Object_id */}
        <p className='small'>
          <strong>ObjectID: </strong>{props.value.object_id}
        </p>

        {/* Stop points */}
        <p className='small'>
          <strong>Stop points: </strong>
        </p>
        <ul className='list-group'>
          {props.value.stop_points.map((stopPoint, i) =>
            <li
              key={ i }
              className='list-group-item clearfix'
            >
              <span className='label label-default' style={{marginRight: 5}}>{stopPoint.id}</span>
              <span>{stopPoint.name}</span>
              <span className='pull-right'>
                <input
                  onChange = {(e) => props.onCheckboxChange(e)}
                  type='checkbox'
                  id={stopPoint.id}
                  checked={stopPoint.checked}
                  disabled={props.value.deletable ? 'disabled' : ''}
                ></input>
              </span>
            </li>
          )}
        </ul>
      </div>

      <div className='clearfix' style={{display: 'inline-block', verticalAlign: 'top', width: '25px'}}>
        <button className={(props.value.deletable ? 'disabled' : '') + ' btn btn-xs btn-danger pull-right'} onClick={props.onOpenEditModal} data-toggle='modal' data-target='#JourneyPatternModal'>
          <span className='fa fa-pencil'></span>
        </button>
      </div>
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
