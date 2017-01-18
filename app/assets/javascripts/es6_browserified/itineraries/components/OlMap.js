var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes

class OlMap extends Component{
  constructor(props){
    super(props)
  }
  componentDidUpdate(prev, next) {
    if(prev.value.olMap.isOpened == false){
      var map = new ol.Map({
        target: 'stoppoint_map' + this.props.index,
        layers: [
        new ol.layer.Tile({
          source: new ol.source.OSM(),
          projection: 'EPSG:4326'
        })
        ],
        controls: [ new ol.control.ScaleLine() ],
        interactions: ol.interaction.defaults({
          dragPan: false
        }),
        view: new ol.View({
          center: ol.proj.fromLonLat([2.349014, 48.864716]),
          zoom: 18,
          projection: 'EPSG:4326'
        })
      });
      // TODO when fetching, use extent value in EPSG 4326
      // var extent = map.getView().calculateExtent(map.getSize());
      // ol.proj.transformExtent(a,"EPSG:3857",'EPSG:4326')
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
