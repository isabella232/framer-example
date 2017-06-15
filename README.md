# Build Framer prototypes with Mapbox  

_Last updated for Framer V93_

# Basic set up 🔧 

### 1. Get an API access token
Sign up and get a Mapbox access token from [the token page](https://www.mapbox.com/studio/account/tokens/). We recommend you create a custom token for all your projects instead of using the default token so it's easier to track usage. Note your token must include all the public scopes.

### 2. Install `mapbox-gl` npm package
Create a new Framer project. In terminal, `cd` to your project and do `npm install mapbox-gl` to install the mapbox-gl package. Then create a new file named `npm.coffee` inside the `modules` folder. You will need to do this inside a text editor.  In `npm.coffee`, insert this line:

```
exports.mapboxgl = require "mapbox-gl"
```
To learn more about how Framer works with npm packages read [this section](mapboxgl.accessToken) of the Framer doc.

### 3. Import `mapboxgl` into your project

Open your project in Framer and insert:

```
mapboxgl = require("npm").mapboxgl
```

Now your can use the object of mapboxgl such as `mapboxgl.Map`. To learn more about the methods and properties available read the [Mapbox GL JS documentation](https://www.mapbox.com/mapbox-gl-js/api/#map). 


# Explore examples 🌟 

Open your project in Framer and copy paste the code in `app.coffee`. Note that you will still need to use your own access token. 

- [Create a simple map view](https://github.com/mapbox/framer-example/tree/master/simple-map-view)
- [Update data in real time](https://github.com/mapbox/framer-example/tree/master/dataset-api)

<img src="https://user-images.githubusercontent.com/5186564/27195034-06eb4722-51d3-11e7-828f-2d69752980f8.gif" />

# Select a map style 🌍 

When you add a new `mapboxgl.Map` object, you will need to specify a map style URL. You can select from one of the [six default map styles](https://www.mapbox.com/mapbox-gl-js/api/#map). Or you can design your own style in [Mapbox Studio](https://www.mapbox.com/mapbox-studio/), which gives you full control over color, font and other details. To use your custom style, go to the [style listing page](https://www.mapbox.com/studio/styles/), click on the hamburger icon, and copy paste the URL from the popover.

![hey](https://user-images.githubusercontent.com/5186564/27195772-0b37e9a4-51d6-11e7-9d67-53e645270785.gif)

# Design @1x 🖌 

Mapbox automatically loads 2x map tiles based on screen pixel density (retina or normal screen). But when you are requesting a 2x pixel-sized map to fit in a 1x container, the map will appear shrinked and map labels will not be readible. It's better set your zoom level at 100% and always design @1x. 
