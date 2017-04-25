var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes
var actions = require('../actions')

class SaveJourneyPattern extends Component{
  constructor(props){
    super(props)
  }

  componentDidUpdate(prevProps, prevState) {
    if(prevProps.status.isFetching == true){
      $(window).scrollTop(0);
      submitMover();
    }
  }

  render() {
    if(this.props.status.isFetching == true || (this.props.status.policy['journey_patterns.edit'] == false)) {
      return false
    }
    if(this.props.status.fetchSuccess == true) {
      return (
        <div className='row mt-md'>
          <div className='col-lg-12 text-right'>
            <form className='jp_collection formSubmitr ml-xs' onSubmit={e => {e.preventDefault()}}>
              <button
                className='btn btn-default'
                type='button'
                onClick={e => {
                  e.preventDefault()
                  actions.submitJourneyPattern(this.props.dispatch, this.props.journeyPatterns)
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

SaveJourneyPattern.propTypes = {
  journeyPatterns: PropTypes.array.isRequired,
  status: PropTypes.object.isRequired,
  page: PropTypes.number.isRequired
}

module.exports = SaveJourneyPattern
