var React = require('react')
var PropTypes = require('react').PropTypes
let weekDays = ['D', 'L', 'Ma', 'Me', 'J', 'V', 'S']

const Metas = ({metas, onUpdateDayTypes}) => {
  let colorList = ["", "#9B9B9B", "#FFA070", "#C67300", "#7F551B", "#41CCE3", "#09B09C", "#3655D7",   "#6321A0", "#E796C6", "#DD2DAA"]
  return (
    <div className="row">
      <div className="col-lg-8 col-lg-offset-2 col-md-8 col-md-offset-2 col-sm-10 col-sm-offset-1">
        <div className='form-horizontal'>
          <div className="row">
            <div className="col-lg-12">
              {/* comment (name) */}
              <div className="form-group">
                <label htmlFor="" className="control-label col-sm-4 required">
                  Nom <abbr title="Champ requis">*</abbr>
                </label>
                <div className="col-sm-8">
                  <input
                    type='text'
                    className='form-control'
                    value={metas.comment}
                    />
                </div>
              </div>

              {/* color */}
              <div className="form-group">
                <label htmlFor="" className="control-label col-sm-4">Couleur associée</label>
                <div className="col-sm-8">
                  <div className="dropdown color_selector">
                    <button
                      type='button'
                      className="btn btn-default dropdown-toggle"
                      id='dpdwn_color'
                      data-toggle='dropdown'
                      aria-haspopup='true'
                      aria-expanded='true'
                      >
                      <span
                        className='fa fa-circle mr-xs'
                        style={{color: metas.color}}
                        ></span>
                      <span className='caret'></span>
                    </button>

                    <div className="form-group dropdown-menu" aria-labelledby='dpdwn_color'>
                      {colorList.map((c, i) =>
                        <span className="radio" key={i}>
                          <label htmlFor="">
                            <input
                              type='radio'
                              className='color_selector'
                              value={c}
                              />
                            <span
                              className='fa fa-circle'
                              style={{color: ((c == '') ? 'transparent' : c)}}
                              ></span>
                          </label>
                        </span>
                      )}
                    </div>
                  </div>
                </div>
              </div>

              {/* tags */}
              <div className="form-group">
                <label htmlFor="" className="control-label col-sm-4">Etiquettes</label>
                <div className="col-sm-8">
                  {/* Select2 to implement*/}
                  <input type="text" value='ton papa' className='form-control'/>
                </div>
              </div>

              {/* day_types */}
              <div className="form-group">
                <label htmlFor="" className="control-label col-sm-4">
                  Journées d'applications pour les périodes ci-dessous
                </label>
                <div className="col-sm-8">
                  <div className="form-group labelled-checkbox-group">
                    {metas.day_types.map((day, i) =>
                      <div className="lcbx-group-item"
                        key={i}
                      >
                        <div className="checkbox">
                          <label>
                            <input
                              onChange={(e) => {onUpdateDayTypes(i)}}
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
      </div>
    </div>
  )
}

Metas.propTypes = {
  metas: PropTypes.object.isRequired,
  onUpdateDayTypes: PropTypes.func.isRequired
}

module.exports = Metas
