# Define custom device
Framer.DeviceView.Devices["custom"] =
	"deviceType": "phone"
	"screenWidth": 375
	"screenHeight": 667
	"deviceImage": ""
	"deviceImageWidth": 375
	"deviceImageHeight": 667

# Set custom device
Framer.Device.deviceType = "custom"
{ mapbox, mapboxgl } = require "npm"

mapboxAccessDatasetToken = ""
datasetID = "ciqs4qb3r02s6fynnibkq1rir"
mapboxClient = new mapbox(mapboxAccessDatasetToken)
blue = "4A90E2"

# Set up map background
Canvas.backgroundColor = blue
mapHeight = 670
mapWidth = 375 

mapboxLayer = new Layer
mapboxLayer.ignoreEvents = false
mapboxLayer.width = mapWidth
mapboxLayer.height = mapHeight
mapboxLayer.html = "<div id='map'></div>"
mapElement = mapboxLayer.querySelector("#map")
mapElement.style.height = mapHeight + 'px'
mapboxgl.accessToken = ''

map = new mapboxgl.Map({
  container: mapElement
  zoom: 11
  center: [-99.13,19.43]
  style: 'mapbox://styles/mapbox/light-v8'
  hash: true
})


# Fetch latest data and update map and marker content
mapboxClient.listFeatures(datasetID,{},
   (err, dataset) -> 
   	  print err if err
).then((data) -> 
  generateMap(data)
  generateContent(data)
)

# Generate markers on the map
generateMap = (dataset) -> 
   # Load dataset as a source
   map.on("load", () -> 
      map.addSource("points", 
        {"type": "geojson", "data": 
          {"type": "FeatureCollection", 
          "features": dataset.features}
      })
   )
   dataset.features.forEach (feature, i) ->
     # Create an image element     
     img = document.createElement('img')
     img.className = "location-marker"
     img.id = "location" + i
     img.style.backgroundImage = "url('images/" + (i + 1) + ".png')"
     marker = new mapboxgl.Marker(img)
        .setLngLat(feature.geometry.coordinates).addTo(map)
     img.addEventListener("click",() -> 
     	isAlreadyActive = img.classList.contains('active')
     	removeAllActive()
     	if isAlreadyActive
     	    markerContent.animate
     	      properties: 
     	        opacity: 0
     	    return 
        else
     	    img.classList.add('active')
     	    markerContent.animate
     	      properties: 
     	        opacity: 1
     	    markerContent.states.switch(img.id) 
     	    return 
     )

# Remove all active marker classes 
removeAllActive = () ->
  highlightedMarkers = document.querySelectorAll('.active')
  for highlightMarker,i in highlightedMarkers
    highlightMarker.classList.remove('active')
      
# Generate HTML a marker
generateMarkerContent = (feature) -> 
  return "<div class='round space-top0 pad2'><div>" + generateStar(feature.properties.review_score) + "<span class='location-score strong space-right0'>" +
    feature.properties.review_score + "</span>" + "<span class='dim'> (" + 
    feature.properties.review_count + " ratings)</span>" + "</div><div class='space-top1_5 big strong'>" + 
    feature.properties.place_name + "</div><div class='dim space-top1 '>" + feature.properties.address + "</div><div class='round space-top1_5 center strong button'>Learn more<div></div>"

# Update content for each marker 
generateContent = (dataset) -> 
  markerContent.states.add
    location0:
      html: generateMarkerContent(dataset.features[0])
    location1:
      html: generateMarkerContent(dataset.features[1])
    location2:
      html: generateMarkerContent(dataset.features[2])
    location3:
      html: generateMarkerContent(dataset.features[3])
    location4:
      html: generateMarkerContent(dataset.features[4])
    location5:
      html: generateMarkerContent(dataset.features[5])
    location6:
      html: generateMarkerContent(dataset.features[6])

markerContent = new Layer
  width: 339; y: Align.bottom(-20); x: 18;
  color: '#343434'
  opacity: 0
  backgroundColor: "#fff"
  borderRadius: 6
  height: 220
markerContent.states.add
  empty:
    html: ""
    opacity: 0
      
layerBg = new BackgroundLayer
  backgroundColor: "#ffffff"
layerMenu = new Layer
  parent: menuBar
  image: "images/icon_w.png"
  width: 21; height: 15; index: 2; x: 16; y: 18
layerFilterButton = new Layer
  parent: menuBar
  backgroundColor: "transparent"
  color: blue
  html: "<strong>Filter</strong>"
  width: 38; height: 23; index: 2; x: 328; y: 14
menuBar = new Layer
  backgroundColor: "#fff"
  width: 375; height: 48; index: 1   



markerContent .on Events.Click, ->
  i = parseInt(markerContent.states.current.replace(/[^0-9\.]/g, ''))

  mapboxClient.listFeatures(datasetID,{},
   (err, dataset) -> 
   	  print err if err
  ).then((data) -> 
  	contentPage.opacity = 1
  	contentPage.html = generateContentPage(data.features[i], i)
  )

generateContentPage = (feature, i) -> 
  contentPageImage.image = "images/" + (i + 1) + ".png"
  generateContentPageContent(feature)
  star = Number(feature.properties.review_score)
  generateStar(star)
  
contentPage = new Layer
  height: Screen.height
  width: Screen.width
  opacity: 0

contentPageMenuBar = new Layer
  parent: contentPage
  backgroundColor: "#fff"
  width: 375; height: 48; index: 1
backButton = new Layer
  parent: contentPageMenuBar
  backgroundColor: "transparent"
  color: blue
  html: "<strong>Back to list</strong>"
  width: 114; height: 19; index: 2; x: 15; y: 16
contentPageImage = new Layer
  parent: contentPage
  width: 375
  height: 222
  y: 48

contentPageContent = new Layer
  parent: contentPage
  y: 270
  width: 375
  height: 467
  color: '#343434'
  backgroundColor: "#fff"



generateContentPageContent = (feature) ->
  contentPageContent.html = "<div class='round space-top0 pad2'><div><span class='keyline-all keyline-blue small text-blue dot'>" + feature.properties.category + "</span></div><div class='space-top2 big strong'>" + 
    feature.properties.place_name + "</div><div class='dim space-top1'><em class=''>" + feature.properties.address + "</em></div><div class='inline dim'><em>Phone: " + feature.properties.tel + "</em></div><div class='quiet space-top1_5'>" + feature.properties.description + "</div><div class='space-top2'>" + generateStar(feature.properties.review_score) + "<span class='strong space-right0 '>" +
    feature.properties.review_score + "</span>" + "<span class='dim'> (" + 
    feature.properties.review_count + " ratings)</span></div>" + "<div class='round space-top2 center strong button'>Rate this<div></div>"
    
generateStar = (rate) -> 
  rate = Number(rate)
  stars = Math.round(rate)
  graystars = 5 - Math.round(rate)
  h = "<div class='star-block inline space-right0'>"
  h = h + "<img src='images/star-blue.png' />" for i in [0...stars]   
  h = h + "<img src='images/star-gray.png' />" for i in [0...graystars]
  h = h + "</div>"

starBlock = new Layer
	y: 556
	height: 33
	backgroundColor: "transparent"
  
    
backButton.on Events.Click, -> 
  contentPage.opacity = 0


rateThis = new Layer
  background: "transparent"
  y: 111; opacity: 1, height: 97, x: 59, width: 269

  
rateThis.on Events.Click, ->
  updateReviewScore(2, 3.2)

updateReviewScore = (i, score) -> 
  mapboxClient.listFeatures(datasetID,{},
    (err, dataset) -> 
      dataset.features[i].properties.review_score = score
      print "hey"
      updateFeature(dataset.features[i])
   )

updateFeature = (feature) -> 
   mapboxClient.insertFeature(feature, datasetID, 
     (err, feature) ->
       print "s"
       print feature
       print feature.properties.review_score 
       generateContentPageContent(feature)
   )




 	
 
 
 
 
 
 