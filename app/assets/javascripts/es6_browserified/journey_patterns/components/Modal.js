var React = require('react')
var PropTypes = require('react').PropTypes

const ModalComponent = (props) => {
  return (
    <div className={ (props.modal.open ? 'in' : '') + ' modal fade' } id='JourneyPatternModal'>
      <div className='modal-dialog'>
        <div className='modal-content'>
          <div className='modal-header'>
            <h4>
              Modifier la mission
              {props.modal.open && (
                <em> "{props.modal.modalProps.journeyPattern.name}"</em>
              )}
            </h4>
          </div>
          <div className='modal-body'>
            {props.modal.open && (
              <p>
                <strong>Name: </strong>
                {props.modal.modalProps.journeyPattern.name}
                <br/>
                <strong>Published name: </strong>
                {props.modal.modalProps.journeyPattern.published_name}
              </p>
            )}
          </div>
          <div className='modal-footer'>
            <button
              className='btn btn-default'
              data-dismiss='modal'
            >
              Annuler
            </button>
            <button
              className='btn btn-danger'
            >
              Valider
            </button>
          </div>
        </div>
      </div>
    </div>
  )
}

ModalComponent.propTypes = {
  index: PropTypes.number,
  modal: PropTypes.object
}

module.exports = ModalComponent
