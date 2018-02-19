import React, { Component } from 'react'
import PropTypes from 'prop-types'
import _ from 'lodash'
import VehicleJourney from './VehicleJourney'
import StopAreaHeaderManager from '../../helpers/stop_area_header_manager'

export default class VehicleJourneys extends Component {
  constructor(props){
    super(props)
    this.headerManager = new StopAreaHeaderManager(
      _.map(this.stopPoints(), (sp)=>{return sp.object_id}),
      this.stopPoints(),
      this.props.filters.features
    )
  }

  isReturn() {
    return this.props.routeUrl != undefined
  }

  vehicleJourneysList() {
    if(this.isReturn()){
      return this.props.returnVehicleJourneys
    }
    else{
      return this.props.vehicleJourneys
    }
  }

  stopPoints() {
    if(this.isReturn()){
      return this.props.returnStopPointsList
    }
    else{
      return this.props.stopPointsList
    }
  }

  componentDidMount() {
    this.props.onLoadFirstPage(this.props.filters, this.props.routeUrl)
  }

  hasFeature(key) {
    return this.props.filters.features[key]
  }

  showHeader(object_id) {
    return this.headerManager.showHeader(object_id)
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
                <strong>{I18n.tc("error")}</strong>
                {I18n.t("vehicle_journeys.vehicle_journeys_matrix.fetching_error")}
              </div>
            )}

            { this.vehicleJourneysList().errors && this.vehicleJourneysList().errors.length && _.some(this.vehicleJourneysList(), 'errors') && (
              <div className="alert alert-danger mt-sm">
                <strong>{I18n.tc("error")}</strong>
                {this.vehicleJourneysList().map((vj, index) =>
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

            <div className={'table table-2entries mt-sm mb-sm' + ((this.vehicleJourneysList().length > 0) ? '' : ' no_result')}>
              <div className='t2e-head w20'>
                <div className='th'>
                  <div className='strong mb-xs'>{I18n.attribute_name("vehicle_journey", "id")}</div>
                  <div>{I18n.attribute_name("vehicle_journey", "name")}</div>
                  <div>{I18n.attribute_name("vehicle_journey", "journey_pattern_id")}</div>
                  <div>{I18n.model_name("company")}</div>
                  <div>{I18n.model_name("time_table", "plural": true)}</div>
                  { this.hasFeature('purchase_windows') && <div>{I18n.model_name("purchase_window", "plural": true)}</div> }
                </div>
                {this.stopPoints().map((sp, i) =>{
                  return (
                    <div key={i} className='td'>
                      {this.headerManager.stopPointHeader(sp.object_id)}
                    </div>
                  )
                })}
              </div>

              <div className='t2e-item-list w80'>
                <div>
                  {this.vehicleJourneysList().map((vj, index) =>
                    <VehicleJourney
                      value={vj}
                      key={index}
                      index={index}
                      editMode={this.isReturn() ? false : this.props.editMode}
                      filters={this.props.filters}
                      features={this.props.features}
                      onUpdateTime={this.props.onUpdateTime}
                      onSelectVehicleJourney={this.props.onSelectVehicleJourney}
                      vehicleJourneys={this}
                      disabled={this.isReturn()}
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
