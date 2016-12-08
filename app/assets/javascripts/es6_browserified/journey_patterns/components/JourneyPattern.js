var React = require('react')
var PropTypes = require('react').PropTypes

const JourneyPattern = (props) => {
  return (
    <div className='list-group-item'>
      <span className='label label-default' style={{marginRight: 10}}>{props.index}</span>
      <span className='label label-default' style={{marginRight: 10}}>{props.value.name}</span>
      <span className='label label-default' style={{marginRight: 10}}>{props.value.object_id}</span>
      <span className='label label-default' style={{marginRight: 10}}>{props.value.published_name}</span>
    </div>
  )
}

JourneyPattern.propTypes = {
  value: PropTypes.object
}

module.exports = JourneyPattern
