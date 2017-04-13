var React = require('react')
var PropTypes = require('react').PropTypes
let weekDays = ['L', 'Ma', 'Me', 'J', 'V', 'S', 'D']

const reorderArray = (arr) =>{
  let elt = arr.shift()
  arr.push(elt)
  return arr
}

const Metas = ({day_types}) => {
  day_types = reorderArray(day_types)
  return (
    <div>
      <h2>Metas</h2>
        <div className="form-group labelled-checkbox-group">
          {day_types.map((day, i) =>
            <div className="lcbx-group-item"
              key={i}
            >
              <div className="checkbox">
                <label>
                  <input
                    onChange={(e) => {e.preventDefault()}}
                    id={i}
                    type="checkbox"
                    checked={day ? 'checked' : ''}
                  />
                  <span className='lcbx-group-item-label'>{weekDays[i]}</span>
                </label>
              </div>
            </div>
          )}
        </div>
    </div>
  )
}

Metas.propTypes = {
  day_types: PropTypes.array.isRequired
}

module.exports = Metas
