class RoutesMap
  constructor: (@target)->
    @initMap()
    @area = []
    @seenStopIds = []
    @routes = {}

  initMap: ->
    @map = new ol.Map
      target: @target,
      layers:   [ new ol.layer.Tile(source: new ol.source.OSM()) ]
      controls: [ new ol.control.ScaleLine(), new ol.control.Zoom(), new ol.control.ZoomSlider() ],
      interactions: ol.interaction.defaults(zoom: true)
      view: new ol.View()

  addRoutes: (routes)->
    for route in routes
      @addRoute route

  addRoute: (route)->
    geoColPts = []
    geoColLns = []
    @routes[route.id] = route if route.id
    stops = route.stops || route
    geoColEdges = [
      new ol.Feature({
        geometry: new ol.geom.Point(ol.proj.fromLonLat([parseFloat(stops[0].longitude), parseFloat(stops[0].latitude)]))
      }),
      new ol.Feature({
        geometry: new ol.geom.Point(ol.proj.fromLonLat([parseFloat(stops[stops.length - 1].longitude), parseFloat(stops[stops.length - 1].latitude)]))
      })
    ]
    stops.forEach (stop, i) =>
      if i < stops.length - 1
        geoColLns.push new ol.Feature
          geometry: new ol.geom.LineString([
            ol.proj.fromLonLat([parseFloat(stops[i].longitude), parseFloat(stops[i].latitude)]),
            ol.proj.fromLonLat([parseFloat(stops[i + 1].longitude), parseFloat(stops[i + 1].latitude)])
          ])

      geoColPts.push(new ol.Feature({
        geometry: new ol.geom.Point(ol.proj.fromLonLat([parseFloat(stop.longitude), parseFloat(stop.latitude)]))
      }))
      unless @seenStopIds.indexOf(stop.stoparea_id) > 0
        @area.push [parseFloat(stop.longitude), parseFloat(stop.latitude)]
        @seenStopIds.push stop.stoparea_id

    vectorPtsLayer = new ol.layer.Vector({
      source: new ol.source.Vector({
        features: geoColPts
      }),
      style: @defaultStyles(),
      zIndex: 2
    })
    route.vectorPtsLayer = vectorPtsLayer if route.id
    vectorEdgesLayer = new ol.layer.Vector({
      source: new ol.source.Vector({
        features: geoColEdges
      }),
      style: @edgeStyles(),
      zIndex: 3
    })
    route.vectorEdgesLayer = vectorEdgesLayer if route.id
    vectorLnsLayer = new ol.layer.Vector({
      source: new ol.source.Vector({
        features: geoColLns
      }),
      style: [@lineStyle()],
      zIndex: 1
    })
    route.vectorLnsLayer = vectorLnsLayer if route.id
    @map.addLayer vectorPtsLayer
    @map.addLayer vectorEdgesLayer
    @map.addLayer vectorLnsLayer

  lineStyle: (highlighted=false)->
    new ol.style.Style
      stroke: new ol.style.Stroke
        color: if highlighted then "#ed7f00" else '#007fbb'
        width: 3

  edgeStyles: (highlighted=false)->
    new ol.style.Style
      image: new ol.style.Circle
        radius: 5
        stroke: new ol.style.Stroke
          color: if highlighted then "#ed7f00" else '#007fbb'
          width: 2
        fill: new ol.style.Fill
          color: if highlighted then "#ed7f00" else '#007fbb'
          width: 2

  defaultStyles: (highlighted=false)->
    new ol.style.Style
      image: new ol.style.Circle
        radius: 4
        stroke: new ol.style.Stroke
          color: if highlighted then "#ed7f00" else '#007fbb'
          width: 2
        fill: new ol.style.Fill
          color: '#ffffff'
          width: 2

  addRoutesLabels: ->
    labelsContainer = $("<ul class='routes-labels'></ul>")
    labelsContainer.appendTo $("##{@target}")
    @vectorPtsLayer = null
    @vectorEdgesLayer = null
    @vectorLnsLayer = null
    Object.keys(@routes).forEach (id)=>
      route = @routes[id]
      label = $("<li>#{route.name}</ul>")
      label.appendTo labelsContainer
      label.mouseleave =>
        route.vectorPtsLayer.setStyle @defaultStyles(false)
        route.vectorEdgesLayer.setStyle @edgeStyles(false)
        route.vectorLnsLayer.setStyle @lineStyle(false)
        route.vectorPtsLayer.setZIndex 2
        route.vectorEdgesLayer.setZIndex 3
        route.vectorLnsLayer.setZIndex 1
        @fitZoom()
      label.mouseenter =>
        route.vectorPtsLayer.setStyle @defaultStyles(true)
        route.vectorEdgesLayer.setStyle @edgeStyles(true)
        route.vectorLnsLayer.setStyle @lineStyle(true)
        route.vectorPtsLayer.setZIndex 11
        route.vectorEdgesLayer.setZIndex 12
        route.vectorLnsLayer.setZIndex 10
        @fitZoom(route)

  fitZoom: (route)->
    if route
      area = []
      route.stops.forEach (stop, i) =>
        area.push [parseFloat(stop.longitude), parseFloat(stop.latitude)]
    else
      area = @area
    boundaries = ol.extent.applyTransform(
      ol.extent.boundingExtent(area), ol.proj.getTransform('EPSG:4326', 'EPSG:3857')
    )
    @map.getView().fit boundaries, @map.getSize()
    tooCloseToBounds = false
    mapBoundaries = @map.getView().calculateExtent @map.getSize()
    mapWidth = mapBoundaries[2] - mapBoundaries[0]
    mapHeight = mapBoundaries[3] - mapBoundaries[1]
    marginSize = 0.1
    heightMargin = marginSize * mapHeight
    widthMargin = marginSize * mapWidth
    tooCloseToBounds = tooCloseToBounds || (boundaries[0] - mapBoundaries[0]) < widthMargin
    tooCloseToBounds = tooCloseToBounds || (mapBoundaries[2] - boundaries[2]) < widthMargin
    tooCloseToBounds = tooCloseToBounds || (boundaries[1] - mapBoundaries[1]) < heightMargin
    tooCloseToBounds = tooCloseToBounds || (mapBoundaries[3] - boundaries[3]) < heightMargin
    if tooCloseToBounds
      @map.getView().setZoom(@map.getView().getZoom() - 1)


export default RoutesMap
