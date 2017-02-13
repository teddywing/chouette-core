var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes
var VehicleJourney = require('./VehicleJourney')

class VehicleJourneys extends Component{
  constructor(props){
    super(props)
  }
  componentDidMount() {
    this.props.onLoadFirstPage()
  }

  render() {
    if(this.props.status.isFetching == true) {
      return (
        <div className="isLoading" style={{marginTop: 80, marginBottom: 80}}>
          <div className="loader"></div>
        </div>
      )
    } else {
      return (
        <div className='list-group'>
          {(this.props.status.fetchSuccess == false) && (
            <div className="alert alert-danger">
              <strong>Erreur : </strong>
              la récupération des missions a rencontré un problème. Rechargez la page pour tenter de corriger le problème
            </div>
          )}
          {this.props.vehicleJourneys.map((vj, index) =>
            <VehicleJourney
              value = {vj}
              key = {index}
              filters = {this.props.filters}
              />
          )}
        </div>
      )
    }
  }
}

VehicleJourneys.propTypes = {
  status: PropTypes.object.isRequired,
  onLoadFirstPage: PropTypes.func.isRequired,
  filters: PropTypes.object.isRequired
}

module.exports = VehicleJourneys
