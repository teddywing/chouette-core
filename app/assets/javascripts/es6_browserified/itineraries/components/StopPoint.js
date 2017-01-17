var React = require('react')
var PropTypes = require('react').PropTypes
var BSelect2 = require('./BSelect2')
var OlMap = require('./OlMap')

const StopPoint = (props) => {
  return (
    <div className='list-group-item'>
      <div className='row'>
        <div className='col-lg-5 col-md-5 col-sm-4 col-xs-5'>
          <div style={{display: 'inline-block', width: '17%', verticalAlign: 'middle', textAlign: 'right', marginTop: 24}}>
            <span className='label label-default' style={{marginRight: 10}}>{props.value.user_objectid}</span>
          </div>

          <div style={{display: 'inline-block', width: '66%', verticalAlign: 'middle'}}>
            <label>Arrêt</label>
            <BSelect2 id={'route_stop_points_' + props.id} value={props.value} onChange={props.onChange} index={props.index} />
          </div>

          <div style={{display: 'inline-block', width: '17%', verticalAlign: 'middle', textAlign: 'right', marginTop: 24}}>
            <div
              className={'btn btn-primary'}
              onClick={props.onToggleMap}
              >
              <span className='fa fa-map-marker'></span>
            </div>
          </div>
        </div>

        <div className='col-lg-2 col-md-2 col-sm-2 col-xs-2'>
          <div style={{display: 'inline-block', width: '100%', verticalAlign: 'middle'}}>
            <label>Montée</label>
            <select className='form-control' value={props.value.for_boarding} id="for_boarding" onChange={props.onSelectChange}>
              <option value="normal">Montée autorisée</option>
              <option value="forbidden">Montée interdite</option>
            </select>
          </div>
        </div>
        <div className='col-lg-2 col-md-2 col-sm-2 col-xs-2'>
          <div style={{display: 'inline-block', width: '100%', verticalAlign: 'middle'}}>
            <label>Descente</label>
            <select className='form-control' value={props.value.for_alighting} id="for_alighting" onChange={props.onSelectChange}>
              <option value="normal">Descente autorisée</option>
              <option value="forbidden">Descente interdite</option>
            </select>
          </div>
        </div>

        <div className='col-lg-3 col-md-3 col-sm-4 col-xs-3' style={{textAlign: 'right'}}>
          <div className='btn-group btn-group-sm' style={{marginTop: 24}}>
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
      <div className="row">
        <div className='col-lg-12 col-md-12 col-sm-12 col-xs-12'>
          <OlMap
            value = {props.value}
            index = {props.index}
            />
        </div>
      </div>
    </div>
  )
}

StopPoint.propTypes = {
  onToggleMap: PropTypes.func.isRequired,
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

module.exports = StopPoint
