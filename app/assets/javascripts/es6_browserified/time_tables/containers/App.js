var React = require('react')
var connect = require('react-redux').connect
var Component = require('react').Component
var actions = require('../actions')
var Metas = require('./Metas')
var Timetable = require('./Timetable')
var Navigate = require('./Navigate')
var PeriodForm = require('./PeriodForm')
var SaveTimetable = require('./SaveTimetable')
var ConfirmModal = require('./ConfirmModal')
var ErrorModal = require('./ErrorModal')

class App extends Component {
  componentDidMount(){
    this.props.onLoadFirstPage()
  }

  render(){
    return(
      <div className='row'>
        <div className="col-lg-8 col-lg-offset-2 col-md-8 col-md-offset-2 col-sm-10 col-sm-offset-1">
          <Metas />
          <Navigate />
          <Timetable />
          <PeriodForm />
          <SaveTimetable />
          <ConfirmModal />
          <ErrorModal />
        </div>
      </div>
    )
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    onLoadFirstPage: () =>{
      dispatch(actions.fetchingApi())
      actions.fetchTimeTables(dispatch)
    }
  }
}

const timeTableApp = connect(null, mapDispatchToProps)(App)

module.exports = timeTableApp
