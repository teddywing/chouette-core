var React = require('react')
var PropTypes = require('react').PropTypes
var StopPoint = require('./StopPoint')

const StopPointList = ({ stopPoints, onDeleteClick, onMoveUpClick, onMoveDownClick, onChange, onSelectChange, onToggleMap }) => {
  return (
    <div className='list-group'>
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
  onSelectChange: PropTypes.func.isRequired
}

module.exports = StopPointList
