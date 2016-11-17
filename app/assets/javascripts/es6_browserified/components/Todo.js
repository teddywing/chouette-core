var React = require('react')
var PropTypes = require('react').PropTypes
var BSelect2 = require('./BSelect2')

const Container = {display: 'table', tableLayout: 'fixed', width: '100%'}
const firstBlock = {display: 'table-cell', verticalAlign: 'middle', width: '55%'}
const secondBlock = {display: 'table-cell', verticalAlign: 'middle', textAlign: 'right'}
const thirdBlock = {display: 'table-cell', verticalAlign: 'middle', width: 125, textAlign: 'right'}

const Todo = (props) => {
  return (
    <div className='list-group-item' style={Container}>
      <div style={firstBlock}>
        <div style={{display: 'inline-block', width: '10%', verticalAlign: 'middle', textAlign: 'right'}}>
          <span className='label label-default' style={{marginRight: 10}}>{props.value.stoparea_id}</span>
        </div>

        <div style={{display: 'inline-block', width: '90%', verticalAlign: 'middle'}}>
          <BSelect2 id={'route_stop_points_' + props.id} value={props.value} onChange={props.onChange} index={props.index} />
        </div>
      </div>
      <div style={secondBlock}>
        <div style={{display: 'inline-block', width: '100%', verticalAlign: 'middle'}}>
          <select value={props.value.for_boarding} id="for_boarding" onChange={props.onSelectChange}>
            <option value="forbidden">interdit</option>
            <option value="normal">normal</option>
          </select>
        </div>
      </div>
      <div style={secondBlock}>
        <div style={{display: 'inline-block', width: '100%', verticalAlign: 'middle'}}>
          <select value={props.value.for_alighting} id="for_alighting" onChange={props.onSelectChange}>
            <option value="forbidden">interdit</option>
            <option value="normal">normal</option>
          </select>
        </div>
      </div>

      <div style={thirdBlock}>
        <div className='btn-group btn-group-sm'>
          <div
            className={'btn btn-primary' + (props.first ? ' disabled' : '')}
            onClick={props.onMoveUpClick}
          >
            <span className='fa fa-arrow-up'></span>
          </div>
          <div
            className={'btn btn-primary' + (props.last ? ' disabled' : '')}
            onClick={props.onMoveDownClick}
          >
            <span className='fa fa-arrow-down'></span>
          </div>
          <div
            className='btn btn-danger'
            onClick={props.onDeleteClick}
          >
            <span className='fa fa-trash'></span>
          </div>
        </div>
      </div>
    </div>
  )
}

Todo.propTypes = {
  onDeleteClick: PropTypes.func.isRequired,
  onMoveUpClick: PropTypes.func.isRequired,
  onMoveDownClick: PropTypes.func.isRequired,
  onChange: PropTypes.func.isRequired,
  onSelectChange: PropTypes.func.isRequired,
  first: PropTypes.bool,
  last: PropTypes.bool,
  index: PropTypes.number,
  value: PropTypes.object
}

module.exports = Todo
