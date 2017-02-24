var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes
var JourneyPattern = require('./JourneyPattern')

class JourneyPatterns extends Component{
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
        <div className='list-group mt-sm mb-sm'>
          {(this.props.status.fetchSuccess == false) && (
            <div className="alert alert-danger">
              <strong>Erreur : </strong>
              la récupération des missions a rencontré un problème. Rechargez la page pour tenter de corriger le problème
            </div>
          )}
          {this.props.journeyPatterns.map((journeyPattern, index) =>
            <JourneyPattern
              value={ journeyPattern }
              key={ index }
              onCheckboxChange= {(e) => this.props.onCheckboxChange(e, index)}
              onOpenEditModal= {() => this.props.onOpenEditModal(index, journeyPattern)}
              />
          )}
        </div>
      )
    }
  }
}

JourneyPatterns.propTypes = {
  journeyPatterns: PropTypes.array.isRequired,
  status: PropTypes.object.isRequired,
  onCheckboxChange: PropTypes.func.isRequired,
  onLoadFirstPage: PropTypes.func.isRequired,
  onOpenEditModal: PropTypes.func.isRequired
}

module.exports = JourneyPatterns
