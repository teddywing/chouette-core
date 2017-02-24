var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes
var actions = require('../../actions')

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
        className='btn btn-primary btn-sm'
        onClick={() => this.props.onToggleFootnoteModal(lf, false)}
      >Retirer</button>
    }else{
      return <button
        type='button'
        className='btn btn-primary btn-sm'
        onClick={() => this.props.onToggleFootnoteModal(lf, true)}
      >Ajouter</button>
    }
  }

  render() {
    if(this.props.status.isFetching == true) {
      return false
    }
    if(this.props.status.fetchSuccess == true) {
      return (
        <div  className='pull-left'>
          <button
            disabled= {(actions.getSelected(this.props.vehicleJourneys).length == 1 && this.props.filters.policy['vehicle_journeys.edit']) ? false : true}
            type='button'
            className='btn btn-primary btn-sm'
            data-toggle='modal'
            data-target='#NotesEditVehicleJourneyModal'
            onClick={() => this.props.onOpenNotesEditModal(actions.getSelected(this.props.vehicleJourneys)[0])}
            >
            <span className='fa fa-paw'></span>
            </button>

            <div className={ 'modal fade ' + ((this.props.modal.type == 'duplicate') ? 'in' : '') } id='NotesEditVehicleJourneyModal'>
              <div className='modal-dialog'>
                <div className='modal-content'>
                  <div className='modal-header clearfix'>
                    <h4>Notes</h4>
                  </div>

                  {(this.props.modal.type == 'notes_edit') && (
                    <form>
                      <div className='modal-body'>
                        {window.line_footnotes.map((lf, i) =>
                          <div
                            key = {i}
                          >
                            <span>Titre: {lf.label} </span>
                            <span>Contenu: {lf.code}</span>
                            {this.renderFootnoteButton(lf, this.props.modal.modalProps.vehicleJourney.footnotes)}
                          </div>
                        )}
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
          </div>
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
