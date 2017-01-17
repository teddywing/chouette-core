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
       target: 'CUSTOM_map' + this.props.index,
       layers: [
         new ol.layer.Tile({
           source: new ol.source.OSM()
         })
       ],
       view: new ol.View({
         center: ol.proj.fromLonLat([37.41, 8.82]),
         zoom: 4
       })
      });
    }
  }

  render() {
    if (this.props.value.olMap.isOpened){
      return <div id={"CUSTOM_map" + this.props.index}></div>
    }else{
      return false
    }
  }
}

OlMap.propTypes = {
}

module.exports = OlMap
