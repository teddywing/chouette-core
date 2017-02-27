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
  componentDidUpdate(prevProps, prevState) {
    if(prevProps.status.isFetching == true){
      $('.table-2entries').each(function() {
        var refH = []
        var refCol = []

        $(this).find('.t2e-head').children('div').each(function() {
          var h = $(this).outerHeight();
          refH.push(h)
        });

        var i = 0
        $(this).find('.t2e-item').children('div').each(function() {
          var h = $(this).outerHeight();
          if(refCol.length < refH.length){
            refCol.push(h)
          } else {
            if(h > refCol[i]) {
              refCol[i] = h
            }
          }
          if(i == (refH.length - 1)){
            i = 0
          } else {
            i++
          }
        });

        for(var n = 0; n < refH.length; n++) {
          if(refCol[n] < refH[n]) {
            refCol[n] = refH[n]
          }
        }

        // console.log(refCol);
        $(this).find('.th').css('height', refCol[0]);

        for(var nth = 1; nth < refH.length; nth++) {
          $(this).find('.td:nth-child('+ (nth + 1) +')').css('height', refCol[nth]);
        }
      });
    }
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

            <div className='table table-2entries mt-sm mb-sm'>
              <div className='t2e-head w20'>
                <div className='th'>
                  <div className='strong mb-xs'>ID Mission</div>
                  <div>Code mission</div>
                  <div>Nb arrêts</div>
                </div>
                {this.props.stopPointsList.map((sp, i) =>
                  <div key={i} className='td'>{sp}</div>
                )}
              </div>

              <div className='t2e-item-list w80'>
                <div>
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
