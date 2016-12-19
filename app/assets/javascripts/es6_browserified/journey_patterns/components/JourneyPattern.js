var React = require('react')
var PropTypes = require('react').PropTypes

const JourneyPattern = (props) => {
  return (
    <div className='list-group-item'>
      <p className='small'><strong>Index: </strong>{props.index}</p>
      <p className='small'><strong>Name: </strong>{props.value.name}</p>
      <p className='small'><strong>ObjectID: </strong>{props.value.object_id}</p>
      <p className='small'><strong>Published name: </strong>{props.value.published_name}</p>

      <p className='small'><strong>Stop points: </strong></p>
      <ul>
        {props.value.stop_points.map((stopPoint, index) =>
          <li
            key={ index }
          >
            <span>{stopPoint.id}</span><span>{stopPoint.name}</span><span>{stopPoint.checked.toString()}</span>
          </li>
        )}
      </ul>
    </div>
  )
}

JourneyPattern.propTypes = {
  value: PropTypes.object,
  index: PropTypes.number
}

module.exports = JourneyPattern
