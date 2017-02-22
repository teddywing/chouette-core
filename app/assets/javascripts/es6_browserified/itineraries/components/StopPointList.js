var React = require('react')
var PropTypes = require('react').PropTypes
var StopPoint = require('./StopPoint')

const StopPointList = ({ stopPoints, onDeleteClick, onMoveUpClick, onMoveDownClick, onChange, onSelectChange, onToggleMap, onToggleEdit, onSelectMarker, onUnselectMarker, onUpdateViaOlMap }) => {
  return (
    <div className='subform'>
      <div className='nested-head'>
        <div className="wrapper">
          <div style={{width: 90}}>
            <div className="form-group">
              <label className="control-label">ID Codif</label>
            </div>
          </div>
          <div>
            <div className="form-group">
              <label className="control-label required">
                Arrêt <abbr title="requis">*</abbr>
            </label>
            </div>
          </div>
          <div>
            <div className="form-group">
              <label className="control-label required">
                Montée <abbr title="requis">*</abbr>
            </label>
            </div>
          </div>
          <div>
            <div className="form-group">
              <label className="control-label required">
                Descente <abbr title="requis">*</abbr>
            </label>
            </div>
          </div>
          <div className='actions-5'></div>
        </div>
      </div>
      {stopPoints.map((stopPoint, index) =>
        <StopPoint
          key={'item-' + index}
          onDeleteClick={() => onDeleteClick(index)}
          onMoveUpClick={() => {
            onMoveUpClick(index)
          }}
          onMoveDownClick={() => onMoveDownClick(index)}
          onChange={ onChange }
          onSelectChange={ (e) => onSelectChange(e, index) }
          onToggleMap={() => onToggleMap(index)}
          onToggleEdit={() => onToggleEdit(index)}
          onSelectMarker={onSelectMarker}
          onUnselectMarker={onUnselectMarker}
          onUpdateViaOlMap={onUpdateViaOlMap}
          first={ index === 0 }
          last={ index === (stopPoints.length - 1) }
          index={ index }
          value={ stopPoint }
        />
      )}
    </div>
  )
}

StopPointList.propTypes = {
  stopPoints: PropTypes.array.isRequired,
  onDeleteClick: PropTypes.func.isRequired,
  onMoveUpClick: PropTypes.func.isRequired,
  onMoveDownClick: PropTypes.func.isRequired,
  onSelectChange: PropTypes.func.isRequired,
  onSelectMarker: PropTypes.func.isRequired,
  onUnselectMarker : PropTypes.func.isRequired
}

module.exports = StopPointList
