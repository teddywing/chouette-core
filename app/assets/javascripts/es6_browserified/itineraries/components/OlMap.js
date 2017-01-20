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
    return origin + path + "/autocomplete_stop_areas/" + id + "/around"

    // let req = new Request(urlJSON, {
    //   credentials: 'same-origin',
    //   method: 'GET',
    //   contentType: 'application/json; charset=utf-8',
    //   Accept: 'application/json',
    //   headers: {
    //     'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    //   }
    // })
    // fetch(req)
    //   .then(response => {
    //     if(!response.ok) {
    //       return false
    //     }
    //     return response.json()
    //   }).then((json) => {
    //     console.log(json)
    //   })
  }

  componentDidUpdate(prevProps, prevState){
    if(prevProps.value.olMap.isOpened == false && this.props.value.olMap.isOpened == true){
      var that = this
      var vectorLayer = new ol.layer.Vector({
          source: new ol.source.Vector({
              format: new ol.format.GeoJSON(),
              url: 'https://gist.githubusercontent.com/ThomasHaddad/7dcc32af24feea2fc4a329445c91af17/raw/4346a71a37326f055ff4fe576eaeb0040596c916/5.geojson'
          }),
          style: new ol.style.Style({
              image: new ol.style.Circle(({
                  radius: 4,
                  fill: new ol.style.Fill({
                      color: '#000000'
                  })
              }))
          })
      });
      var map = new ol.Map({
        target: 'stoppoint_map' + that.props.index,
        layers: [
        new ol.layer.Tile({
          source: new ol.source.OSM()
        }),
        vectorLayer
        ],
        controls: [ new ol.control.ScaleLine() ],
        interactions: ol.interaction.defaults({
          dragPan: false
        }),
        view: new ol.View({
          center: ol.proj.fromLonLat([2.3477774, 48.869183, ]),
          zoom: 18
        })
      });
      // let extent = map.getView().calculateExtent(map.getSize())
      // setTimeout(()=>{
      //   that.fetchApiForMap(extent, that.props.value.stoparea_id)
      // }, 1000)
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
