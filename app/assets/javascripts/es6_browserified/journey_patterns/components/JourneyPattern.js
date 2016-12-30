var React = require('react')
var PropTypes = require('react').PropTypes

const JourneyPattern = (props) => {
  return (
    <div className={(props.value.deletable ? 'disabled' : '') + ' list-group-item'}>
      <div style={{display: 'inline-block', verticalAlign: 'top', width: '40%'}}>
        <p className='small'><strong>Index: </strong>{props.index}</p>
        <p className='small'><strong>Name: </strong>{props.value.name}</p>
      </div>

      <div style={{display: 'inline-block', verticalAlign: 'top', width: '40%'}}>
        <p className='small'><strong>ObjectID: </strong>{props.value.object_id}</p>
        <p className='small'><strong>Published name: </strong>{props.value.published_name}</p>
      </div>

      <div className='clearfix' style={{display: 'inline-block', verticalAlign: 'top', width: '20%'}}>
        <button className={(props.value.deletable ? 'disabled' : '') + ' btn btn-xs btn-danger pull-right'} onClick={props.onUpdateModalOpen} data-toggle='modal' data-target='#JourneyPatternModal'>
          <span className='fa fa-pencil'></span>
        </button>
      </div>

      <p className='small'><strong>Stop points: </strong></p>
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
                disabled={props.value.deletable ? 'true' : 'false'}
              ></input>
            </span>
          </li>
        )}
      </ul>
    </div>
  )
}

JourneyPattern.propTypes = {
  value: PropTypes.object,
  index: PropTypes.number,
  onCheckboxChange: PropTypes.func.isRequired,
  onUpdateModalOpen: PropTypes.func.isRequired
}

module.exports = JourneyPattern
