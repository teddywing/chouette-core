var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes

class OlMap extends Component{
  constructor(props){
    super(props)
  }

  fetchApiForMap(extent, id){
    const origin = window.location.origin
    const path = window.location.pathname.split('/', 3).join('/')
    let params = []
    for ( var i = 0; i < extent.length; i++ )
      params.push(encodeURIComponent(i) + '=' + encodeURIComponent(extent[i]))
    params = params.join("&")
    const urlJSON = origin + path + "/autocomplete_stop_areas/" + id + "/around?" + params


    let req = new Request(urlJSON, {
      credentials: 'same-origin',
      method: 'GET',
      contentType: 'application/json; charset=utf-8',
      Accept: 'application/json',
      headers: {
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
      }
    })
    fetch(req)
      .then(response => {
        if(!response.ok) {
          return false
        }
        return response.json()
      }).then((json) => {
        console.log(json)
      })
  }

  componentDidUpdate(prevProps, prevState){
    if(prevProps.value.olMap.isOpened == false && this.props.value.olMap.isOpened == true){
      var that = this
      var map = new ol.Map({
        target: 'stoppoint_map' + that.props.index,
        layers: [
        new ol.layer.Tile({
          source: new ol.source.OSM()
        })
        ],
        controls: [ new ol.control.ScaleLine() ],
        interactions: ol.interaction.defaults({
          dragPan: false
        }),
        view: new ol.View({
          center: ol.proj.fromLonLat([2.349014, 48.864716]),
          zoom: 18
        })
      });
      let extent = map.getView().calculateExtent(map.getSize())
      setTimeout(()=>{
        that.fetchApiForMap(extent, that.props.value.stoparea_id)
      }, 1000)
      // TODO when fetching, use extent value in EPSG 4326
      // var extent = map.getView().calculateExtent(map.getSize());
    }
  }

  render() {
    if (this.props.value.olMap.isOpened) {
      return <div id={"stoppoint_map" + this.props.index} className='map'></div>
    } else {
      return false
    }
  }
}

OlMap.propTypes = {
}

module.exports = OlMap
