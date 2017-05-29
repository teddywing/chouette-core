var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes
var actions = require('../../actions')
var TimetableSelect2 = require('./select2s/TimetableSelect2')

class TimetablesEditVehicleJourney extends Component {
  constructor(props) {
    super(props)
  }

  handleSubmit() {
    this.props.onTimetablesEditVehicleJourney(this.props.modal.modalProps.vehicleJourneys, this.props.modal.modalProps.timetables)
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
          <button
            type='button'
            disabled={(actions.getSelected(this.props.vehicleJourneys).length > 0 && this.props.filters.policy['vehicle_journeys.edit']) ? '' : 'disabled'}
            data-toggle='modal'
            data-target='#CalendarsEditVehicleJourneyModal'
            onClick={() => this.props.onOpenCalendarsEditModal(actions.getSelected(this.props.vehicleJourneys))}
          >
            <span className='fa fa-calendar'></span>
          </button>

          <div className={ 'modal fade ' + ((this.props.modal.type == 'duplicate') ? 'in' : '') } id='CalendarsEditVehicleJourneyModal'>
            <div className='modal-container'>
              <div className='modal-dialog'>
                <div className='modal-content'>
                  <div className='modal-header'>
                    <h4 className='modal-title'>Calendriers associés</h4>
                  </div>

                  {(this.props.modal.type == 'calendars_edit') && (
                    <form>
                      <div className='modal-body'>
                        <div className='row'>
                          <div className='col-lg-12'>
                            <div className='subform'>
                              <div className='nested-head'>
                                <div className='wrapper'>
                                  <div>
                                    <div className='form-group'>
                                      <label className='control-label'>Calendriers associés</label>
                                    </div>
                                  </div>
                                  <div></div>
                                </div>
                              </div>
                              {this.props.modal.modalProps.timetables.map((tt, i) =>
                                <div className='nested-fields' key={i}>
                                  <div className='wrapper'>
                                    <div>{tt.comment}</div>
                                    <div>
                                      <a
                                        href='#'
                                        title='Supprimer'
                                        className='fa fa-trash remove_fields'
                                        style={{height: 'auto', lineHeight: 'normal'}}
                                        onClick={(e) => {
                                          e.preventDefault()
                                          this.props.onDeleteCalendarModal(tt)
                                        }}
                                        ></a>
                                    </div>
                                  </div>
                                </div>
                              )}
                              <div className='nested-fields'>
                                <div className='wrapper'>
                                  <div>
                                    <TimetableSelect2
                                      onSelect2Timetable={this.props.onSelect2Timetable}
                                      chunkURL={'/autocomplete_time_tables.json'}
                                      isFilter={false}
                                    />
                                  </div>
                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>

                      <div className='modal-footer'>
                        <button
                          className='btn btn-link'
                          data-dismiss='modal'
                          type='button'
                          onClick={this.props.onModalClose}
                          >
                          Annuler
                        </button>
                        <button
                          className='btn btn-primary'
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
          </div>
        </li>
      )
    } else {
      return false
    }
  }
}

TimetablesEditVehicleJourney.propTypes = {
  onOpenCalendarsEditModal: PropTypes.func.isRequired,
  onModalClose: PropTypes.func.isRequired,
  onTimetablesEditVehicleJourney: PropTypes.func.isRequired,
  onDeleteCalendarModal: PropTypes.func.isRequired,
  onSelect2Timetable: PropTypes.func.isRequired,
  filters: PropTypes.object.isRequired
}

module.exports = TimetablesEditVehicleJourney
