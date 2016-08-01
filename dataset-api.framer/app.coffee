# Define custom device
Framer.DeviceView.Devices["custom"] =
	deviceType: "phone"
	screenWidth: 375
	screenHeight: 667
	deviceImage: ""
	deviceImageWidth: 375
	deviceImageHeight: 667

# Set custom device
Framer.Device.deviceType = "custom"
{ mapbox, mapboxgl } = require "npm"

# This is a private access token
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
mapElement.style.height = "#{mapHeight}px"

# This is a public access token
mapboxgl.accessToken = ""

map = new mapboxgl.Map({
  container: mapElement
  zoom: 11
  center: [-99.13,19.43]
  style: 'mapbox://styles/mapbox/light-v8'
  hash: true
})


# Fetch latest data and update map and marker content
mapboxClient.listFeatures(datasetID, {},
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
      map.addSource("points",  {
      	type: "geojson",
      	data: {
          type: "FeatureCollection", 
          features: dataset.features
        }
      })
   )
   dataset.features.forEach (feature, i) ->
     # Create an image element     
     img = document.createElement('img')
     img.className = "location-marker"
     img.id = "location#{i}"
     img.style.backgroundImage = "url('images/#{(i + 1)}.png')"
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
generateMarkerContent = (feature) -> """
    <div class='round space-top0 pad2'><div>#{generateStar(feature.properties.review_score)}
    <span class='location-score strong space-right0'>#{feature.properties.review_score}
    </span><span class='dim'> (#{feature.properties.review_count} ratings)</span>
    </div><div class='space-top1_5 big strong'>#{feature.properties.place_name}</div>
    <div class='dim space-top1 '>#{feature.properties.address}</div>
    <div class='round space-top1_5 center strong button'>Learn more<div></div>
   """

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
  width: 21; height: 15; index: 2; x: 337; y: 18
layerMenu.states.add
  listButton: 
    image: "images/icon_w.png"
  mapButton: 
    image: "images/map.png"
menuBar = new Layer
  backgroundColor: "#fff"
  width: 375; height: 48; index: 1   

layerMenu .on Events.Click, ->
  if !locationList.visible
    locationList.visible = true
    layerMenu.states.switch("mapButton")
  else 
    locationList.visible = false
    layerMenu.states.switch("listButton")

markerContent .on Events.Click, ->
  i = parseInt(markerContent.states.current.replace(/[^0-9\.]/g, ''))
  
  mapboxClient.listFeatures(datasetID,{},
   (err, dataset) -> 
   	  print err if err
  ).then((data) -> 
  	contentPage.visible = true
  	contentPage.html = generateContentPage(data.features[i], i)
  )

generateContentPage = (feature, i) -> 
  contentPageImage.image = "images/#{i + 1}.png"
  generateContentPageContent(feature)
  generateRateModalContent(feature)
  generateRateConfirmButton(feature, i)
  star = Number(feature.properties.review_score)
  generateStar(star)
  
contentPage = new Layer
  height: Screen.height
  width: Screen.width
  x: 0
  visible: false

contentPageMenuBar = new Layer
  parent: contentPage
  backgroundColor: "#fff"
  width: 375; height: 48; index: 1
backButton = new Layer
  parent: contentPageMenuBar
  backgroundColor: "transparent"
  color: blue
  html: "<strong>Back</strong>"
  width: 114; height: 19; index: 2; x: 32; y: 17
backButtonImage = new Layer
  parent: backButton
  image: "images/back.png"
  width: 12
  height: 12
  x: -20
  y: 4
   
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
  contentPageContent.html = """
  <div class='round space-top0 pad2'>
  	<div>
  	<span class='keyline-all keyline-blue small text-blue dot'>
  	  #{feature.properties.category}
  	</span>
  </div>
  <div class='space-top2 big strong'>#{feature.properties.place_name}</div>
  <div class='dim space-top1'><em class=''>#{feature.properties.address}</em></div>
  <div class='inline dim'><em>Phone: #{feature.properties.tel}</em></div>
  <div class='quiet space-top1_5'>#{feature.properties.description}</div>
  <div class='space-top2'>#{generateStar(feature.properties.review_score)}
  	<span class='strong space-right0 '>#{feature.properties.review_score}</span>
  	<span class='dim'> (#{feature.properties.review_count} ratings)</span>
  </div>
  <div class='round space-top2 center strong button'>Rate this<div></div>
  """
    
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
  contentPage.visible = false


rateModalBg = new Layer
  width: Screen.width
  height: Screen.height
  visible: false

rateModal = new Layer
  parent: rateModalBg
  x: rateModalBg.midX - 157
  width: 314
  borderRadius: 4
  backgroundColor: "rgba(255,255,255,1)"
  height: 239
  y: 159

rateModalContent = new Layer
  parent: rateModal
  color: '#343434'
  width: rateModal.width
  height: rateModal.height
  backgroundColor: "transparent"

generateRateModalContent = (feature) ->
  rateModalContent.html = """
  	<div class='pad2 center'>
  	<div class='space-top2  big strong'>
  	#{feature.properties.place_name}
  	</div><div class='small dim space-top1'>
  	<em>Click on the stars to rate</em>
  	</div>
  	</div>
  	"""

rateModalStarSection = new Layer
  html: "<div class='big-star center'>#{generateStar(0)}</div>"
  parent: rateModalContent
  backgroundColor: "transparent"
  y: 115
  x: (rateModalContent.width - 226)/2 + 4
  width: 226

rateStarModal = new Layer
  parent: rateModalStarSection
  backgroundColor: "transparent"
  width: 211
  height: 40


[0,1,2,3,4].forEach (i) ->
  rateThis = new Layer
    parent: rateModalStarSection
    width: 44
    backgroundColor: "transparent" 
    height: 40
    x: (i * 44) - 4
  rateThis .on Events.Click, ->
  	rateModalStarSection.html = "<div class='big-star center'>#{generateStar(i+1)}</div>"
  confirmRateThis = new Layer
    parent: rateModalContent
    backgroundColor: "transparent"
    html: "<div class='round space-top2 center strong button'>Confirm<div>"
    width: 256; x: 32; y: 154
  confirmRateThis .on Events.Click, ->
  	featureIndex = parseInt(markerContent.states.current.replace(/[^0-9\.]/g, ''))
  	updateReviewScore(featureIndex, i)

updateReviewScore = (i, newScore) -> 
  mapboxClient.listFeatures datasetID, {}, (err, dataset) -> 
      feature = dataset.features[i]
      oldScore = feature.properties.review_score
      oldCount = feature.properties.review_count
      dataset.features[i].properties.review_score =
      (oldScore *  
       oldCount + newScore)/(oldCount + 1)
      dataset.features[i].properties.review_count = oldCount + 1
      updateFeature(dataset.features[i])

updateFeature = (feature) -> 
   mapboxClient.insertFeature feature, datasetID, (err, feature) ->
       generateContentPageContent(feature)
       clearRateModal()

rateThisButton = new Layer
  parent: contentPageContent
  y: 337
  height: 40
  width: 375
  opacity: 0
rateThisButton .on Events.Click, ->
  rateModalBg.visible = true
clearRateModal = () ->
  rateModalBg.visible = false
  rateModalStarSection.html = "<div class='big-star center'>#{generateStar(0)}</div>"



    
locationList = new ScrollComponent
  width: Screen.width
  height: Screen.height - 48
  scrollHorizontal: false
  scrollVertical: true
  y: 47
  visible: false
  
locationListContent = new Layer
  superLayer: locationList.content
  backgroundColor: "#fff"
  height: 1200
  width: Screen.width
 
 
mapboxClient.listFeatures(datasetID,{},
 (err, dataset) -> 
  # print dataset.features if !err
   print err if err
 
   # location grid
   for feature,i in dataset.features
     #img = document.createElement('div')
     location = new Layer
       parent: locationListContent
       width: Screen.width - 40
       height: 166
       x: 20
       y: Align.top(if i > 0 then 166 * i else 5) 
       backgroundColor: "rgba(255,255,255,1)"
       borderRadius: 6
     # content
     locationTitle = new Layer
       parent: location
       html: "<div><span class='small keyline-all keyline-blue text-blue dot'>" + feature.properties.category + "</span></div><div class='space-top1 strong'>" + feature.properties.place_name + "</div><div class='quiet space-top0 small'>" + feature.properties.address + "</div>"
       x: 180
       width: 159
       backgroundColor: "rgba(255,255,255,0.5)"
       color: "#353535"
       height: 139
       y: 23
     
     # image
     locationImage = new Layer
       parent: location
       image: "images/#{i + 1}.png"
       borderRadius: 4
       width: 166
       height: 131
       y: 17
       x: -2
      locationScore = new Layer
        parent: locationImage
        backgroundColor: blue
        html: "<strong><center class='small'>#{feature.properties.review_score}</center></strong>"
        y: 97
        height: 24
        width: 40
        borderRadius: 4
        style:
          "padding-top": "2px"
        x: 9
      
)
 
 
 
 
 
