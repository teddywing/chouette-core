var React = require('react')
var PropTypes = require('react').PropTypes

const ModalComponent = (props) => {
  return (
    <h1 className={ (props.modal.open ? "" : "hidden") + " btn btn-default" }>
      COUCOU {props.index}
    </h1>
  )
}

ModalComponent.propTypes = {
  index: PropTypes.number,
  modal: PropTypes.object
}

module.exports = ModalComponent
