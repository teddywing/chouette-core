var React = require('react')
var PropTypes = require('react').PropTypes
let weekDays = ['L', 'Ma', 'Me', 'J', 'V', 'S', 'D']

const reorderArray = (arr) =>{
  let elt = arr.shift()
  arr.push(elt)
  return arr
}

const Metas = ({metas}) => {
  let day_types = reorderArray(metas.day_types)
  return (
    <div className='form-horizontal'>
      <div className="row">
        <div className="col-lg-12">
          {/* comment (name) */}
          <div className="form-group"></div>

          {/* color */}
          <div className="form-group"></div>

          {/* tags */}
          <div className="form-group"></div>

          {/* day_types */}
          <div className="form-group">
            <label htmlFor="" className="control-label col-sm-4">
              Journées d'applications pour les périodes ci-dessous
            </label>
            <div className="col-sm-8">
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
          </div>
        </div>
      </div>
    </div>
  )
}

Metas.propTypes = {
  metas: PropTypes.object.isRequired
}

module.exports = Metas
