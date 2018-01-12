import React, { Component } from 'react'

export default class StopAreaHeaderManager {
  constructor(ids_list, stopPointsList, features) {
    this.ids_list = ids_list
    this.stopPointsList = stopPointsList
    this.features = features
  }

  hasFeature(key) {
    return this.features[key]
  }

  stopPointHeader(object_id) {
    let index = this.ids_list.indexOf(object_id)
    let sp = this.stopPointsList[index]
    let showHeadline = this.showHeader(object_id)
    return (
      <div
        className={(showHeadline) ? 'headlined' : ''}
        data-headline={showHeadline}
        title={sp.city_name + ' (' + sp.zip_code +')'}
      >
        <span>
          <span>
            {sp.name}
            {sp.time_zone_formatted_offset && <span className="small">
              &nbsp;({sp.time_zone_formatted_offset})
            </span>}
          </span>
        </span>
      </div>
    )
  }

  showHeader(object_id) {
    let showHeadline = false
    let headline = ""
    let attribute_to_check = this.hasFeature('long_distance_routes') ? "country_code" : "city_name"
    let index = this.ids_list.indexOf(object_id)
    let sp = this.stopPointsList[index]
    let previousBreakpoint = this.stopPointsList[index - 1]
    if(index == 0 || (sp[attribute_to_check] != previousBreakpoint[attribute_to_check])){
      showHeadline = true
      headline = this.hasFeature('long_distance_routes') ? sp.country_name : sp.city_name
    }
    return showHeadline ? headline : ""
  }
}
