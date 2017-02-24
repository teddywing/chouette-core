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
        <div className='row'>
          <div className='col-lg-12'>
            {(this.props.status.fetchSuccess == false) && (
              <div className="alert alert-danger">
                <strong>Erreur : </strong>
                la récupération des missions a rencontré un problème. Rechargez la page pour tenter de corriger le problème
              </div>
            )}

            <div className='table table-cbyc mt-sm mb-sm'>
              <div className='tc-wrapper'>
                <div className='tc-head'>
                  <div className='tc-th'>
                    <span>ID Mission</span>
                    <span>Code mission</span>
                    <span>Nb arrêts</span>
                  </div>
                  {this.props.stopPointsList.map((sp, i) =>
                    <span key={i} className='tc-td'>{sp}</span>
                  )}
                </div>

                {this.props.journeyPatterns.map((journeyPattern, index) =>
                  <JourneyPattern
                    value={ journeyPattern }
                    key={ index }
                    onCheckboxChange= {(e) => this.props.onCheckboxChange(e, index)}
                    onOpenEditModal= {() => this.props.onOpenEditModal(index, journeyPattern)}
                    />
                )}
              </div>
            </div>
          </div>
        </div>
      )
    }
  }
}

JourneyPatterns.propTypes = {
  journeyPatterns: PropTypes.array.isRequired,
  stopPointsList: PropTypes.array.isRequired,
  status: PropTypes.object.isRequired,
  onCheckboxChange: PropTypes.func.isRequired,
  onLoadFirstPage: PropTypes.func.isRequired,
  onOpenEditModal: PropTypes.func.isRequired
}

module.exports = JourneyPatterns
