var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes
var actions = require('../../actions')
var _ = require('lodash')

class NotesEditVehicleJourney extends Component {
  constructor(props) {
    super(props)
  }

  handleSubmit() {
    this.props.onNotesEditVehicleJourney(this.props.modal.modalProps.vehicleJourney.footnotes)
    this.props.onModalClose()
    $('#NotesEditVehicleJourneyModal').modal('hide')
  }

  renderFootnoteButton(lf, vjArray){
    let footnote_id = undefined
    vjArray.forEach((f) => {
      if(f.id == lf.id){
        footnote_id = f.id
      }
    })

    if(footnote_id){
      return <button
        type='button'
        className='btn btn-outline-danger btn-xs'
        onClick={() => this.props.onToggleFootnoteModal(lf, false)}
      ><span className="fa fa-trash"></span> Retirer</button>
    }else{
      return <button
        type='button'
        className='btn btn-outline-primary btn-xs'
        onClick={() => this.props.onToggleFootnoteModal(lf, true)}
      ><span className="fa fa-plus"></span> Ajouter</button>
    }
  }

  filterFN() {
    return _.filter(window.line_footnotes, (lf, i) => {
      let bool = true
      _.map(this.props.modal.modalProps.vehicleJourney.footnotes, (f, j) => {
        if(lf.id === f.id) {
          bool = false
        }
      })
      return bool
    })
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
            disabled={(actions.getSelected(this.props.vehicleJourneys).length == 1 && this.props.filters.policy['vehicle_journeys.update']) ? '' : 'disabled'}
            data-toggle='modal'
            data-target='#NotesEditVehicleJourneyModal'
            onClick={() => this.props.onOpenNotesEditModal(actions.getSelected(this.props.vehicleJourneys)[0])}
          >
            <span className='fa fa-sticky-note'></span>
          </button>

          <div className={ 'modal fade ' + ((this.props.modal.type == 'duplicate') ? 'in' : '') } id='NotesEditVehicleJourneyModal'>
            <div className='modal-container'>
              <div className='modal-dialog'>
                <div className='modal-content'>
                  <div className='modal-header'>
                    <h4 className='modal-title'>Notes</h4>
                  </div>

                  {(this.props.modal.type == 'notes_edit') && (
                    <form>
                      <div className='modal-body'>
                        <h3>Notes associées</h3>
                        {(this.props.modal.modalProps.vehicleJourney.footnotes).map((lf, i) =>
                          <div
                            key={i}
                            className='panel panel-default'
                          >
                            <div className='panel-heading'>
                              <h4 className='panel-title clearfix'>
                                <div className='pull-left' style={{paddingTop: '3px'}}>{lf.code}</div>
                                <div className='pull-right'>{this.renderFootnoteButton(lf, this.props.modal.modalProps.vehicleJourney.footnotes)}</div>
                              </h4>
                            </div>
                            <div className='panel-body'><p>{lf.label}</p></div>
                          </div>
                        )}

                        <h3 className='mt-lg'>Sélectionnez les notes à associer à cette course :</h3>
                        {this.filterFN().map((lf, i) =>
                          <div
                            key={i}
                            className='panel panel-default'
                          >
                            <div className='panel-heading'>
                              <h4 className='panel-title clearfix'>
                                <div className='pull-left' style={{paddingTop: '3px'}}>{lf.code}</div>
                                <div className='pull-right'>{this.renderFootnoteButton(lf, this.props.modal.modalProps.vehicleJourney.footnotes)}</div>
                              </h4>
                            </div>
                            <div className='panel-body'><p>{lf.label}</p></div>
                          </div>
                        )}
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

NotesEditVehicleJourney.propTypes = {
  onOpenNotesEditModal: PropTypes.func.isRequired,
  onModalClose: PropTypes.func.isRequired,
  onToggleFootnoteModal: PropTypes.func.isRequired,
  onNotesEditVehicleJourney: PropTypes.func.isRequired,
  filters: PropTypes.object.isRequired
}

module.exports = NotesEditVehicleJourney
