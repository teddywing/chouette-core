var React = require('react')
var PropTypes = require('react').PropTypes

const Container = {display: 'table',  width: '100%'}
const firstBlock = {display: 'table-cell', verticalAlign: 'middle'}
const secondBlock = {display: 'table-cell', verticalAlign: 'middle', width: '150px', textAlign: 'right'}

const Todo = (props)  => (
  <div className='list-group-item' style={Container}>
    <div style={firstBlock}>
      <div style={{display: 'inline-block', width: '9%'}}>
        <span className='strong'>Id: {props.id}</span>
      </div>
      <div style={{display: 'inline-block', width: '91%'}}>
        <input type='text' className='form-control' id={'route_stop_points_' + props.id}/>
      </div>
    </div>

    <div style={secondBlock}>
      <div className='btn-group btn-group-sm'>
        <div className='btn btn-default'>
          <span className='fa fa-times'></span>
        </div>
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

Todo.propTypes = {
  onDeleteClick: PropTypes.func.isRequired,
  onMoveUpClick: PropTypes.func.isRequired,
  onMoveDownClick: PropTypes.func.isRequired,
  first: PropTypes.bool,
  last: PropTypes.bool
}

module.exports = Todo
