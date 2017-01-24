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
            stroke: new ol.style.Stroke({
              color: '#000000',
              width: 2
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
          dragPan: false,
          doubleClickZoom: false,
          shiftDragZoom: false,
          mouseWheelZoom: false
        }),
        view: new ol.View({
          center: ol.proj.fromLonLat([2.3477774, 48.869183, ]),
          zoom: 18
        })
      });

      // Selectable marker
      var select = new ol.interaction.Select({
        style: new ol.style.Style({
          image: new ol.style.Circle(({
            radius: 4,
            fill: new ol.style.Fill({
              color: '#000000'
            })
          }))
        })
      });
      map.addInteraction(select);
      select.on('select', function(e) {
        if(e.selected.length != 0){
          var data = e.selected[0];
          console.log('Selected item');
          console.log('id:' + data.getId());
          console.log('LonLat:' + data.getGeometry().getCoordinates());
        }
      });

    }
  }

  render() {
    if (this.props.value.olMap.isOpened) {
      return (
        <div className='row'>
          <div className="col-lg-4 col-md-4 col-sm-4 col-xs-4" style={{marginTop: 15}}>
            <p><strong>Nom de l'arrêt : </strong>XXX</p>
            <p className='small'><strong>Nom public : </strong>XXX</p>
            <p className='small'><strong>N° d'enregistrement : </strong>XXX</p>
            <p className='small'><strong>Réseau : </strong>XXX</p>

            <div className='btn btn-primary btn-sm'>Sélectionner</div>
          </div>
          <div className='col-lg-8 col-md-8 col-sm-8 col-xs-8'>
            <div id={"stoppoint_map" + this.props.index} className='map'></div>
          </div>
        </div>
      )
    } else {
      return false
    }
  }
}

OlMap.propTypes = {
}

module.exports = OlMap
