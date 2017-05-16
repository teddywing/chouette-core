route = JSON.parse(decodeURIComponent(route))
const geoColPts = []
const geoColLns= []
const geoColEdges = [
  new ol.Feature({
    geometry: new ol.geom.Point(ol.proj.fromLonLat([parseFloat(route[0].longitude), parseFloat(route[0].latitude)]))
  }),
  new ol.Feature({
    geometry: new ol.geom.Point(ol.proj.fromLonLat([parseFloat(route[route.length - 1].longitude), parseFloat(route[route.length - 1].latitude)]))
  })
]
route.forEach(function(stop, i){
  if (i < route.length - 1){
    geoColLns.push(new ol.Feature({
      geometry: new ol.geom.LineString([
        ol.proj.fromLonLat([parseFloat(route[i].longitude), parseFloat(route[i].latitude)]),
        ol.proj.fromLonLat([parseFloat(route[i+1].longitude), parseFloat(route[i+1].latitude)])
      ])
    }))
  }
  geoColPts.push(new ol.Feature({
    geometry: new ol.geom.Point(ol.proj.fromLonLat([parseFloat(stop.longitude), parseFloat(stop.latitude)]))
    })
  )
})
var edgeStyles = new ol.style.Style({
  image: new ol.style.Circle(({
    radius: 5,
    stroke: new ol.style.Stroke({
      color: '#ff0000',
      width: 2
    }),
    fill: new ol.style.Fill({
      color: '#ffffff',
      width: 2
    })
  }))
})
var defaultStyles = new ol.style.Style({
  image: new ol.style.Circle(({
    radius: 5,
    stroke: new ol.style.Stroke({
      color: '#004d87',
      width: 2
    }),
    fill: new ol.style.Fill({
      color: '#ffffff',
      width: 2
    })
  }))
})
var lineStyle = new ol.style.Style({
  stroke: new ol.style.Stroke({
      color: '#0000ff',
      width: 4
  })
})

var vectorPtsLayer = new ol.layer.Vector({
  source: new ol.source.Vector({
    features: geoColPts
  }),
  style: defaultStyles,
  zIndex: 2
})
var vectorEdgesLayer = new ol.layer.Vector({
  source: new ol.source.Vector({
    features: geoColEdges
  }),
  style: edgeStyles,
  zIndex: 3
})
var vectorLnsLayer = new ol.layer.Vector({
  source: new ol.source.Vector({
    features: geoColLns
  }),
  style: [lineStyle],
  zIndex: 1
})

var map = new ol.Map({
  target: 'route_map',
  layers: [
    new ol.layer.Tile({
      source: new ol.source.OSM()
    }),
    vectorPtsLayer,
    vectorEdgesLayer,
    vectorLnsLayer
  ],
  controls: [ new ol.control.ScaleLine(), new ol.control.Zoom(), new ol.control.ZoomSlider() ],
  interactions: ol.interaction.defaults({
    zoom: true
  }),
  view: new ol.View({
    center: ol.proj.fromLonLat([parseFloat(route[0].longitude), parseFloat(route[0].latitude)]),
    zoom: 10
  })
});

