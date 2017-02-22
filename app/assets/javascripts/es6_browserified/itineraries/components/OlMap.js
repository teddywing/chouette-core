var React = require('react')
var Component = require('react').Component
var PropTypes = require('react').PropTypes

class OlMap extends Component{
  constructor(props){
    super(props)
  }

  fetchApiURL(id){
    const origin = window.location.origin
    const path = window.location.pathname.split('/', 3).join('/')
    return origin + path + "/autocomplete_stop_areas/" + id + "/around"
  }

  componentDidUpdate(prevProps, prevState){
    if(prevProps.value.olMap.isOpened == false && this.props.value.olMap.isOpened == true){
      var source = new ol.source.Vector({
        format: new ol.format.GeoJSON(),
        url: this.fetchApiURL(this.props.value.stoparea_id)
      })
      var feature = new ol.Feature({
        geometry: new ol.geom.Point(ol.proj.fromLonLat([parseFloat(this.props.value.longitude), parseFloat(this.props.value.latitude)])),
      })

      var selectedStyles = new ol.style.Style({
        image: new ol.style.Circle(({
          radius: 5,
          fill: new ol.style.Fill({
            color: '#da2f36'
          })
        }))
      })
      var defaultStyles = new ol.style.Style({
        image: new ol.style.Circle(({
          radius: 5,
          fill: new ol.style.Fill({
            color: '#004d87'
          })
        }))
      })

      var centerLayer = new ol.layer.Vector({
        source: new ol.source.Vector({
          features: [feature]
        }),
        style: new ol.style.Style({
          image: new ol.style.Circle(({
            radius: 7,
            stroke: new ol.style.Stroke({
              color: '#da2f36',
              width: 1
            })
          }))
        }),
        zIndex: 1
      })
      var vectorLayer = new ol.layer.Vector({
        source: source,
        style: defaultStyles,
        zIndex: 2
      });

      var map = new ol.Map({
        target: 'stoppoint_map' + this.props.index,
        layers: [
          new ol.layer.Tile({
            source: new ol.source.OSM()
          }),
          vectorLayer,
          centerLayer
        ],
        controls: [ new ol.control.ScaleLine() ],
        interactions: ol.interaction.defaults({
          dragPan: false,
          doubleClickZoom: false,
          shiftDragZoom: false,
          mouseWheelZoom: false
        }),
        view: new ol.View({
          center: ol.proj.fromLonLat([parseFloat(this.props.value.longitude), parseFloat(this.props.value.latitude)]),
          zoom: 18
        })
      });

      // Selectable marker
      var select = new ol.interaction.Select({
        style: selectedStyles
      });

      map.addInteraction(select);

      select.on('select', function(e) {
        if(e.selected.length != 0){
          let data = Object.assign({}, e.selected[0].getProperties(), {geometry: undefined});
          this.props.onSelectMarker(this.props.index, data)
        } else {
          this.props.onUnselectMarker(this.props.index)
        }
      }, this);

    }
  }

  render() {
    if (this.props.value.olMap.isOpened) {
      return (
        <div className='row'>
          <div className="col-lg-4 col-md-4 col-sm-4 col-xs-4" style={{marginTop: 15}}>
            <p>
              <strong>Nom de l'arrêt : </strong>
              {this.props.value.olMap.json.name}
            </p>
            <p className='small'>
              <strong>N° d'enregistrement : </strong>
              {this.props.value.olMap.json.registration_number}
            </p>
            <p className='small'>
              <strong>OiD de l'utilisateur : </strong>
              {this.props.value.olMap.json.user_objectid}
            </p>

            {(this.props.value.stoparea_id != this.props.value.olMap.json.stoparea_id) &&(
              <div className='btn btn-outline-primary btn-sm'
                onClick= {() => {this.props.onUpdateViaOlMap(this.props.index, this.props.value.olMap.json)}}
              >Sélectionner</div>
            )}
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
