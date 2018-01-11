import React, { Component } from 'react'
import PropTypes from 'prop-types'
import actions from '../../actions'
import CompanySelect2 from './select2s/CompanySelect2'
import Select2 from 'react-select2-wrapper'

export default class EditVehicleJourney extends Component {
  constructor(props) {
    super(props)
    this.custom_fields = {}
  }

  handleSubmit() {
    if(actions.validateFields(this.refs) == true) {
      var company = undefined
      if(this.props.modal.modalProps.selectedCompany) {
        company = this.props.modal.modalProps.selectedCompany
      } else if (typeof this.props.modal.modalProps.vehicleJourney.company === "object") {
        company = this.props.modal.modalProps.vehicleJourney.company
      }
      this.props.onEditVehicleJourney(_.assign({}, this.refs, {custom_fields: this.custom_fields}), company)
      this.props.onModalClose()
      $('#EditVehicleJourneyModal').modal('hide')
    }
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
            disabled={(actions.getSelected(this.props.vehicleJourneys).length != 1 || this.props.disabled)}
            data-toggle='modal'
            data-target='#EditVehicleJourneyModal'
            onClick={() => this.props.onOpenEditModal(actions.getSelected(this.props.vehicleJourneys)[0])}
          >
            <span className='fa fa-info'></span>
          </button>

          <div className={ 'modal fade ' + ((this.props.modal.type == 'duplicate') ? 'in' : '') } id='EditVehicleJourneyModal'>
            <div className='modal-container'>
              <div className='modal-dialog'>
                <div className='modal-content'>
                  <div className='modal-header'>
                    <h4 className='modal-title'>Informations</h4>
                    <span type="button" className="close modal-close" data-dismiss="modal">&times;</span>
                  </div>

                  {(this.props.modal.type == 'edit') && (
                    <form>
                      <div className='modal-body'>
                          <div className='row'>
                            <div className='col-lg-6 col-md-6 col-sm-6 col-xs-12'>
                              <div className='form-group'>
                                <label className='control-label'>Nom de la course</label>
                                <input
                                  type='text'
                                  ref='published_journey_name'
                                  className='form-control'
                                  disabled={!this.props.editMode}
                                  defaultValue={this.props.modal.modalProps.vehicleJourney.published_journey_name}
                                  onKeyDown={(e) => actions.resetValidation(e.currentTarget)}
                                  />
                              </div>
                            </div>
                            <div className='col-lg-6 col-md-6 col-sm-6 col-xs-12'>
                              <div className='form-group'>
                                <label className='control-label'>Mission</label>
                                <input
                                  type='text'
                                  className='form-control'
                                  value={this.props.modal.modalProps.vehicleJourney.journey_pattern.short_id + ' - ' + (this.props.modal.modalProps.vehicleJourney.journey_pattern.name)}
                                  disabled={true}
                                />
                              </div>
                            </div>
                          </div>

                        <div className='row'>
                          <div className='col-lg-6 col-md-6 col-sm-6 col-xs-12'>
                            <div className='form-group'>
                              <label className='control-label'>Numéro de train</label>
                              <input
                                type='text'
                                ref='published_journey_identifier'
                                className='form-control'
                                disabled={!this.props.editMode}
                                defaultValue={this.props.modal.modalProps.vehicleJourney.published_journey_identifier}
                                onKeyDown={(e) => actions.resetValidation(e.currentTarget)}
                              />
                            </div>
                          </div>
                          <div className='col-lg-6 col-md-6 col-sm-6 col-xs-12'>
                            <div className='form-group'>
                              <label className='control-label'>Transporteur</label>
                              <CompanySelect2
                                editModal={this.props.modal.type == "edit"}
                                editMode={this.props.editMode}
                                company = {this.props.modal.modalProps.vehicleJourney.company}
                                onSelect2Company = {(e) => this.props.onSelect2Company(e)}
                                onUnselect2Company = {() => this.props.onUnselect2Company()}
                              />
                            </div>
                          </div>
                        </div>

                        <div className='row'>
                          <div className='col-lg-6 col-md-6 col-sm-6 col-xs-12'>
                            <div className='form-group'>
                              <label className='control-label'>Mode de transport</label>
                              <input
                                type='text'
                                className='form-control'
                                value={window.I18n.fr.enumerize.transport_mode[this.props.modal.modalProps.vehicleJourney.transport_mode]}
                                disabled={true}
                              />
                            </div>
                          </div>
                          <div className='col-lg-6 col-md-6 col-sm-6 col-xs-12'>
                            <div className='form-group'>
                              <label className='control-label'>Sous mode de transport</label>
                              <input
                                type='text'
                                className='form-control'
                                value={window.I18n.fr.enumerize.transport_submode[this.props.modal.modalProps.vehicleJourney.transport_submode]}
                                disabled={true}
                              />
                            </div>
                          </div>
                        </div>
                        <div className='form-group'>
                          <label className='control-label'>Signature métier</label>
                            <input
                            type='text'
                            ref='checksum'
                            className='form-control'
                            disabled='disabled'
                            defaultValue={this.props.modal.modalProps.vehicleJourney.checksum}
                            />
                        </div>
                        {_.map(this.props.modal.modalProps.vehicleJourney.custom_fields, (cf, code) =>
                          <div className='form-group' key={code}>
                            <label className='control-label'>{cf.name}</label>
                            <Select2
                              data={_.map(cf.options.list_values, (v, k) => {
                                return {id: k, text: v}
                              })}
                              ref={'custom_fields.' + code}
                              className='form-control'
                              value={cf.value}
                              disabled={!this.props.editMode}
                              options={{theme: 'bootstrap'}}
                              onSelect={(e) => this.custom_fields[code] = e.params.data.id }
                            />
                          </div>
                      )}

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
                            onClick={this.handleSubmit.bind(this)}
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

EditVehicleJourney.propTypes = {
  onOpenEditModal: PropTypes.func.isRequired,
  onModalClose: PropTypes.func.isRequired,
  disabled: PropTypes.bool.isRequired
}
