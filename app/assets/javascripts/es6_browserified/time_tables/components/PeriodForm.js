var React = require('react')
var PropTypes = require('react').PropTypes
let monthsArray = ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre']

const makeDaysOptions = (daySelected) => {
  let arr = []
  for(let i = 1; i < 32; i++) {
    arr.push(<option key={i}>{i}</option>)
  }
  return arr
}

const makeMonthsOptions = (monthSelected) => {
  let arr = []
  for(let i = 1; i < 13; i++) {
    arr.push(<option key={i}>{monthsArray[i - 1]}</option>)
  }
  return arr
}

const makeYearsOptions = (yearSelected) => {
  let arr = []
  let startYear = new Date().getFullYear() - 3
  for(let i = startYear; i <= startYear + 6; i++) {
    arr.push(<option key={i}>{i}</option>)
  }
  return arr
}

const PeriodForm = ({modal, timetable, onOpenAddPeriodForm, onClosePeriodForm, onUpdatePeriodForm}) => (
  <div>
    {modal.modalProps.active &&
      <div className="form-group date filter_menu-item">
        <label className="date required control-label" >Du <abbr title="Champ requis">*</abbr></label>
        <div className="form-inline">
          <select value={modal.modalProps.begin.day} onChange={(e) => onUpdatePeriodForm(e.currentTarget.value, 'begin', 'day')} id="q_validity_period_begin_gteq_3i" className="date required form-control">
            {makeDaysOptions(modal.modalProps.begin.day)}
          </select>
          <select value={modal.modalProps.begin.month} onChange={(e) => onUpdatePeriodForm(e.currentTarget.value, 'begin', 'month')} id="q_validity_period_begin_gteq_2i" className="date required form-control">
            {makeMonthsOptions(modal.modalProps.begin.month)}
          </select>
          <select value={modal.modalProps.begin.year} onChange={(e) => onUpdatePeriodForm(e.currentTarget.value, 'begin', 'year')} id="q_validity_period_begin_gteq_1i" className="date required form-control">
            {makeYearsOptions(modal.modalProps.begin.year)}
          </select>
        </div>
        <label className="date required control-label" >Au <abbr title="Champ requis">*</abbr></label>
        <div className="form-inline">
          <select value={modal.modalProps.end.day} onChange={(e) => onUpdatePeriodForm(e.currentTarget.value, 'end', 'day')} id="q_validity_period_end_gteq_3i" className="date required form-control">
            {makeDaysOptions(modal.modalProps.end.day)}
          </select>
          <select value={modal.modalProps.end.month} onChange={(e) => onUpdatePeriodForm(e.currentTarget.value, 'end', 'month')} id="q_validity_period_end_gteq_2i" className="date required form-control">
            {makeMonthsOptions(modal.modalProps.end.month)}
          </select>
          <select value={modal.modalProps.end.year} onChange={(e) => onUpdatePeriodForm(e.currentTarget.value, 'end', 'year')} id="q_validity_period_end_gteq_1i" className="date required form-control">
            {makeYearsOptions(modal.modalProps.end.year)}
          </select>
        </div>
        <div>
          <button
            onClick={onClosePeriodForm}
          >
          Annuler
          </button>
          <button>Valider</button>
        </div>
      </div>
    }
    {!modal.modalProps.active &&
      <button
        onClick={onOpenAddPeriodForm}
      >
        Ajouter une période
      </button>
    }
  </div>
)

PeriodForm.propTypes = {
  modal: PropTypes.object.isRequired,
  onOpenAddPeriodForm: PropTypes.func.isRequired,
  onClosePeriodForm: PropTypes.func.isRequired,
  onUpdatePeriodForm: PropTypes.func.isRequired,
  timetable: PropTypes.object.isRequired
}

module.exports = PeriodForm
