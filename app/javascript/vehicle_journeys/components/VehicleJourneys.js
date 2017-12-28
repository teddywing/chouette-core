import React, { Component } from 'react'
import PropTypes from 'prop-types'
import _ from 'lodash'
import VehicleJourney from './VehicleJourney'


export default class VehicleJourneys extends Component {
  constructor(props){
    super(props)
    this.previousBreakpoint = undefined
  }
  componentDidMount() {
    this.props.onLoadFirstPage(this.props.filters)
  }

  hasFeature(key) {
    return this.props.filters.features[key]
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

  stopPointHeader(sp) {
    let showHeadline = false
    let headline = ""
    let attribute_to_check = this.hasFeature('long_distance_routes') ? "country_code" : "city_name"
    if(sp[attribute_to_check] != this.previousBreakpoint){
      showHeadline = true
      headline = this.hasFeature('long_distance_routes') ? sp.country_name : sp.city_name
      this.previousBreakpoint = sp[attribute_to_check]
    }
    return (
      <div
        className={(showHeadline) ? 'headlined' : ''}
        data-headline={headline}
        title={sp.city_name + ' (' + sp.zip_code +')'}
      >
        <span><span>{sp.name}</span></span>
      </div>
    )
  }

  render() {
    this.previousBreakpoint = undefined

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
              <div className='alert alert-danger mt-sm'>
                <strong>Erreur : </strong>
                la récupération des missions a rencontré un problème. Rechargez la page pour tenter de corriger le problème.
              </div>
            )}

            { _.some(this.props.vehicleJourneys, 'errors') && (
              <div className="alert alert-danger mt-sm">
                <strong>Erreur : </strong>
                {this.props.vehicleJourneys.map((vj, index) =>
                  vj.errors && vj.errors.map((err, i) => {
                    return (
                      <ul key={i}>
                        <li>{err}</li>
                      </ul>
                    )
                  })
                )}
              </div>
            )}

            <div className={'table table-2entries mt-sm mb-sm' + ((this.props.vehicleJourneys.length > 0) ? '' : ' no_result')}>
              <div className='t2e-head w20'>
                <div className='th'>
                  <div className='strong mb-xs'>ID course</div>
                  <div>Nom course</div>
                  <div>ID mission</div>
                  <div>Transporteur</div>
                  <div>Calendriers</div>
                  { this.hasFeature('purchase_windows') && <div>Calendriers Commerciaux</div> }
                </div>
                {this.props.stopPointsList.map((sp, i) =>{
                  return (
                    <div key={i} className='td'>
                      {this.stopPointHeader(sp)}
                    </div>
                  )
                })}
              </div>

              <div className='t2e-item-list w80'>
                <div>
                  {this.props.vehicleJourneys.map((vj, index) =>
                    <VehicleJourney
                      value={vj}
                      key={index}
                      index={index}
                      editMode={this.props.editMode}
                      filters={this.props.filters}
                      features={this.props.features}
                      onUpdateTime={this.props.onUpdateTime}
                      onSelectVehicleJourney={this.props.onSelectVehicleJourney}
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

VehicleJourneys.propTypes = {
  status: PropTypes.object.isRequired,
  filters: PropTypes.object.isRequired,
  stopPointsList: PropTypes.array.isRequired,
  onLoadFirstPage: PropTypes.func.isRequired,
  onUpdateTime: PropTypes.func.isRequired,
  onSelectVehicleJourney: PropTypes.func.isRequired
}
