import React, { Component } from 'react'
import PropTypes from 'prop-types'
import _ from 'lodash'
import JourneyPattern from './JourneyPattern'


export default class JourneyPatterns extends Component {
  constructor(props){
    super(props)
    this.stopPointsIds = _.map(this.props.stopPointsList, (sp)=>{return sp.stop_area_object_id})
  }

  componentDidMount() {
    this.props.onLoadFirstPage()
  }

  componentDidUpdate(prevProps, prevState) {
    if(this.props.status.isFetching == false){
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

        $(this).find('.th').css('height', refCol[0]);

        for(var nth = 1; nth < refH.length; nth++) {
          $(this).find('.td:nth-child('+ (nth + 1) +')').css('height', refCol[nth]);
        }
      });
    }
  }

  showHeader(object_id) {
    let showHeadline = false
    let headline = ""
    let attribute_to_check = this.hasFeature('long_distance_routes') ? "country_code" : "city_name"
    let index = this.stopPointsIds.indexOf(object_id)
    let sp = this.props.stopPointsList[index]
    let previousBreakpoint = this.props.stopPointsList[index - 1]
    if(index == 0 || (sp[attribute_to_check] != previousBreakpoint[attribute_to_check])){
      showHeadline = true
      headline = this.hasFeature('long_distance_routes') ? sp.country_name : sp.city_name
    }
    return showHeadline ? headline : ""
  }

  stopPointHeader(sp) {
    let showHeadline = this.showHeader(sp.stop_area_object_id)
    return (
      <div
        className={(showHeadline) ? 'headlined' : ''}
        data-headline={showHeadline}
        title={sp.city_name + ' (' + sp.zip_code +')'}
      >
        <span><span>{sp.name}</span></span>
      </div>
    )
  }

  hasFeature(key) {
    return this.props.status.features[key]
  }

  render() {
    this.previousCity = undefined

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
              <div className="alert alert-danger mt-sm">
                <strong>Erreur : </strong>
                la récupération des missions a rencontré un problème. Rechargez la page pour tenter de corriger le problème
              </div>
            )}

            { _.some(this.props.journeyPatterns, 'errors') && (
              <div className="alert alert-danger mt-sm">
                <strong>Erreur : </strong>
                {this.props.journeyPatterns.map((jp, index) =>
                  jp.errors && jp.errors.map((err, i) => {
                    return (
                      <ul key={i}>
                        <li>{err}</li>
                      </ul>
                    )
                  })
                )}
              </div>
            )}

            <div className={'table table-2entries mt-sm mb-sm' + ((this.props.journeyPatterns.length > 0) ? '' : ' no_result')}>
              <div className='t2e-head w20'>
                <div className='th'>
                  <div className='strong mb-xs'>ID Mission</div>
                  <div>Code mission</div>
                  <div>Nb arrêts</div>
                </div>
                {this.props.stopPointsList.map((sp, i) =>{
                  return (
                    <div key={i} className={'td' + (this.hasFeature('costs_in_journey_patterns') ? ' with-costs' : '')}>
                      {this.stopPointHeader(sp)}
                    </div>
                  )
                })}
              </div>

              <div className='t2e-item-list w80'>
                <div>
                  {this.props.journeyPatterns.map((journeyPattern, index) =>
                    <JourneyPattern
                      value={ journeyPattern }
                      key={ index }
                      onCheckboxChange= {(e) => this.props.onCheckboxChange(e, index)}
                      onOpenEditModal= {() => this.props.onOpenEditModal(index, journeyPattern)}
                      onDeleteJourneyPattern={() => this.props.onDeleteJourneyPattern(index)}
                      onUpdateJourneyPatternCosts={(costs) => this.props.onUpdateJourneyPatternCosts(index, costs)}
                      status= {this.props.status}
                      editMode= {this.props.editMode}
                      journeyPatterns= {this}
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
