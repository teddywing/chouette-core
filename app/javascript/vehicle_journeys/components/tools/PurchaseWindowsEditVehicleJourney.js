import React, { PropTypes, Component } from 'react'
import actions from '../../actions'
import TimetableSelect2 from './select2s/TimetableSelect2'

export default class PurchaseWindowsEditVehicleJourney extends Component {
  constructor(props) {
    super(props)
    this.handleSubmit = this.handleSubmit.bind(this)
    this.purchaseWindowURL = this.purchaseWindowURL.bind(this)
  }

  handleSubmit() {
    this.props.onShoppingWindowsEditVehicleJourney(this.props.modal.modalProps.vehicleJourneys, this.props.modal.modalProps.purchase_windows)
    this.props.onModalClose()
    $('#PurchaseWindowsEditVehicleJourneyModal').modal('hide')
  }

  purchaseWindowURL(tt) {
    let refURL = window.location.pathname.split('/', 3).join('/')
    return refURL + '/purchase_windows/' + tt.id
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
            disabled={(actions.getSelected(this.props.vehicleJourneys).length < 1 || this.props.disabled)}
            data-toggle='modal'
            data-target='#PurchaseWindowsEditVehicleJourneyModal'
            onClick={() => this.props.onOpenCalendarsEditModal(actions.getSelected(this.props.vehicleJourneys))}
            title='Calendriers commerciaux'
          >
            <span className='sb sb-purchase_window sb-strong'></span>
          </button>

          <div className={ 'modal fade ' + ((this.props.modal.type == 'duplicate') ? 'in' : '') } id='PurchaseWindowsEditVehicleJourneyModal'>
            <div className='modal-container'>
              <div className='modal-dialog'>
                <div className='modal-content'>
                  <div className='modal-header'>
                    <h4 className='modal-title'>Calendriers commerciaux associés</h4>
                    <span type="button" className="close modal-close" data-dismiss="modal">&times;</span>
                  </div>

                  {(this.props.modal.type == 'purchase_windows_edit') && (
                    <form>
                      <div className='modal-body'>
                        <div className='row'>
                          <div className='col-lg-12'>
                            <div className='subform'>
                              <div className='nested-head'>
                                <div className='wrapper'>
                                  <div>
                                    <div className='form-group'>
                                      <label className='control-label'>{this.props.modal.modalProps.purchase_windows.length == 0 ? "Aucun calendrier commercial associé" : "Calendriers commerciaux associés"}</label>
                                    </div>
                                  </div>
                                  <div></div>
                                </div>
                              </div>
                              {this.props.modal.modalProps.purchase_windows.map((tt, i) =>
                                <div className='nested-fields' key={i}>
                                  <div className='wrapper'>
                                    <div> <a href={this.purchaseWindowURL(tt)} target="_blank">
                                      <span className="fa fa-circle mr-xs" style={{color: tt.color}}></span>
                                      {tt.name}
                                    </a> </div>
                                    {
                                      this.props.editMode &&
                                      <div>
                                        <a
                                          href='#'
                                          title='Supprimer'
                                          className='fa fa-trash remove_fields'
                                          style={{ height: 'auto', lineHeight: 'normal' }}
                                          onClick={(e) => {
                                            e.preventDefault()
                                            this.props.onDeleteCalendarModal(tt)
                                          }}
                                        ></a>
                                      </div>
                                    }
                                  </div>
                                </div>
                              )}
                              {
                                this.props.editMode &&
                                <div className='nested-fields'>
                                  <div className='wrapper'>
                                    <div>
                                      <TimetableSelect2
                                        onSelect2Timetable={this.props.onSelect2Timetable}
                                        chunkURL={'/autocomplete_purchase_windows.json'}
                                        searchKey={"name_or_objectid_cont_any"}
                                        isFilter={false}
                                      />
                                    </div>
                                  </div>
                                </div>
                              }
                            </div>
                          </div>
                        </div>
                      </div>
                      {
                        this.props.editMode &&
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
                            onClick={this.handleSubmit}
                          >
                            Valider
                          </button>
                        </div>
                      }
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

PurchaseWindowsEditVehicleJourney.propTypes = {
  onOpenCalendarsEditModal: PropTypes.func.isRequired,
  onModalClose: PropTypes.func.isRequired,
  onShoppingWindowsEditVehicleJourney: PropTypes.func.isRequired,
  onDeleteCalendarModal: PropTypes.func.isRequired,
  onSelect2Timetable: PropTypes.func.isRequired,
  disabled: PropTypes.bool.isRequired
}