var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes
var actions = require('../../actions')
var TimetableSelect2 = require('./select2s/TimetableSelect2')

class CalendarsEditVehicleJourney extends Component {
  constructor(props) {
    super(props)
  }

  handleSubmit() {
    this.props.onCalendarsEditVehicleJourney(this.props.modal.modalProps.vehicleJourneys)
    this.props.onModalClose()
    $('#CalendarsEditVehicleJourneyModal').modal('hide')
  }

  render() {
    if(this.props.status.isFetching == true) {
      return false
    }
    if(this.props.status.fetchSuccess == true) {
      return (
        <li className='st_action'>
          <a
            href='#'
            className={(actions.getSelected(this.props.vehicleJourneys).length > 0 && this.props.filters.policy['vehicle_journeys.edit']) ? '' : 'disabled'}
            data-toggle='modal'
            data-target='#CalendarsEditVehicleJourneyModal'
            onClick={() => this.props.onOpenCalendarsEditModal(actions.getSelected(this.props.vehicleJourneys))}
          >
            <span className='fa fa-calendar'></span>
          </a>

          <div className={ 'modal fade ' + ((this.props.modal.type == 'duplicate') ? 'in' : '') } id='CalendarsEditVehicleJourneyModal'>
            <div className='modal-dialog'>
              <div className='modal-content'>
                <div className='modal-header clearfix'>
                  <h4>Calendriers associés</h4>
                </div>

                {(this.props.modal.type == 'calendars_edit') && (
                  <form>
                    <div className='modal-body'>
                      <ul>
                      {this.props.modal.modalProps.timetables.map((tt, i) =>
                          <li
                            key= {i}
                          >
                            {tt.comment}
                            <button
                            type='button'
                            onClick={() => this.props.onDeleteCalendarModal(tt)}
                            >
                              <span className='fa fa-times'></span>
                            </button>
                          </li>
                      )}
                      </ul>
                      <div className='row'>
                        <div className='col-lg-6 col-md-6 col-sm-6 col-xs-6'>
                          <div className='form-group'>
                            <label className='control-label is-required'>Ajouter un calendrier</label>
                            <TimetableSelect2 onSelect2Timetable={this.props.onSelect2Timetable} />
                            <button
                              onClick={this.props.onAddSelectedTimetable}
                              type='button'
                            ><span className='fa fa-times'>Ajouter</span>
                            </button>
                          </div>
                        </div>
                      </div>
                    </div>

                    <div className='modal-footer'>
                      <button
                        className='btn btn-default'
                        data-dismiss='modal'
                        type='button'
                        onClick={this.props.onModalClose}
                        >
                        Annuler
                      </button>
                      <button
                        className='btn btn-danger'
                        type='button'
                        onClick={this.handleSubmit.bind(this)}
                        >
                        Valider
                      </button>
                    </div>
                  </form>
                )}

              </div>
            </div>
          </div>
        </li>
      )
    } else {
      return false
    }
  }
}

CalendarsEditVehicleJourney.propTypes = {
  onOpenCalendarsEditModal: PropTypes.func.isRequired,
  onModalClose: PropTypes.func.isRequired,
  onCalendarsEditVehicleJourney: PropTypes.func.isRequired,
  onDeleteCalendarModal: PropTypes.func.isRequired,
  onSelect2Timetable: PropTypes.func.isRequired,
  onAddSelectedTimetable: PropTypes.func.isRequired,
  filters: PropTypes.object.isRequired
}

module.exports = CalendarsEditVehicleJourney
