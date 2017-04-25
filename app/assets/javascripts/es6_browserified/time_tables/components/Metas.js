var React = require('react')
var PropTypes = require('react').PropTypes
let weekDays = ['D', 'L', 'Ma', 'Me', 'J', 'V', 'S']
var TagsSelect2 = require('./TagsSelect2')

const Metas = ({metas, onUpdateDayTypes, onUpdateComment, onUpdateColor, onSelect2Tags, onUnselect2Tags}) => {
  let colorList = ["", "#9B9B9B", "#FFA070", "#C67300", "#7F551B", "#41CCE3", "#09B09C", "#3655D7",   "#6321A0", "#E796C6", "#DD2DAA"]
  return (
    <div className='form-horizontal'>
      <div className="row">
        <div className="col-lg-10 col-lg-offset-1">
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
                required='required'
                onChange={(e) => (onUpdateComment(e.currentTarget.value))}
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
                    style={{color: (metas.color == '')  ? 'transparent' : metas.color}}
                    ></span>
                  <span className='caret'></span>
                </button>

                <div className="form-group dropdown-menu" aria-labelledby='dpdwn_color'>
                  {colorList.map((c, i) =>
                    <span
                      className="radio"
                      key={i}
                      onClick={() => {onUpdateColor(c)}}
                    >
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
          {/* <div className="form-group">
            <label htmlFor="" className="control-label col-sm-4">Etiquettes</label>
            <div className="col-sm-8">
              <TagsSelect2
                tags={metas.tags}
                onSelect2Tags={(e) => onSelect2Tags(e)}
                onUnselect2Tags={(e) => onUnselect2Tags(e)}
              />
              <input type="text" value='ton papa' className='form-control'/>
            </div>
          </div>
          */}

          {/* calendar */}
          <div className="form-group">
            <label htmlFor="" className="control-label col-sm-4">Modèle de calendrier associé</label>
            <div className="col-sm-8">
              <span>{metas.calendar.name}</span>
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
                  <div
                    className='lcbx-group-item'
                    data-wday={'day_' + i}
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
  )
}

Metas.propTypes = {
  metas: PropTypes.object.isRequired,
  onUpdateDayTypes: PropTypes.func.isRequired,
  onUpdateColor: PropTypes.func.isRequired,
  onUpdateColor: PropTypes.func.isRequired,
  onSelect2Tags: PropTypes.func.isRequired,
  onUnselect2Tags: PropTypes.func.isRequired
}

module.exports = Metas
