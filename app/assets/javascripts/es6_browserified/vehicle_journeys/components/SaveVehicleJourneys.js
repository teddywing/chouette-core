var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes
var actions = require('../actions')

class SaveVehicleJourneys extends Component{
  constructor(props){
    super(props)
  }

  componentDidUpdate(prevProps, prevState) {
    if(prevProps.status.isFetching == true) {
      $(window).scrollTop(0);
      submitMover();
    }
  }

  render() {
    if(this.props.status.isFetching == true || this.props.filters.policy['vehicle_journeys.edit'] == false) {
      return false
    }
    if(this.props.status.fetchSuccess == true) {
      return (
        <div className='row mt-md'>
          <div className='col-lg-12 text-right'>
            <form className='vehicle_journeys formSubmitr ml-xs' onSubmit={e => {e.preventDefault()}}>
              <button
                className='btn btn-default'
                type='button'
                onClick={e => {
                  e.preventDefault()
                  actions.submitVehicleJourneys(this.props.dispatch, this.props.vehicleJourneys)
                }}
              >
                Valider
              </button>
            </form>
          </div>
        </div>
      )
    } else {
      return false
    }
  }
}

SaveVehicleJourneys.propTypes = {
  vehicleJourneys: PropTypes.array.isRequired,
  page: PropTypes.number.isRequired,
  status: PropTypes.object.isRequired,
  filters: PropTypes.object.isRequired
}

module.exports = SaveVehicleJourneys
