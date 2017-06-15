# Framer examples built with Mapbox

_Last updated for Framer V93_

## Basic set up

#### 1. Get an API access token
Sign up and get a Mapbox access token from [the token page](https://www.mapbox.com/studio/account/tokens/). We recommend you create a custom token for all your projects instead of using the default token so it's easier to track usage. Note your token must include all the public scopes.

#### 2. Install `mapbox-gl` npm package
Create a new Framer project. In terminal, `cd` to your project and do `npm install mapbox-gl` to install the mapbox-gl package. Then create a new file named `npm.coffee` inside the `modules` folder. You will need to do this inside a text editor.  In `npm.coffee`, insert this line:

```
exports.mapboxgl = require "mapbox-gl"
```
To learn more about how Framer works with npm packages read [this section](mapboxgl.accessToken) of the Framer doc.

#### 3. Import `mapboxgl` into your project

Open your project in Framer and insert:

```
mapboxgl = require("npm").mapboxgl
```

Now your can use the object of mapboxgl such as `mapboxgl.Map`. To learn more about the methods and properties available read the [Mapbox GL JS documentation](https://www.mapbox.com/mapbox-gl-js/api/#map). 


## Explore examples

Open your project in Framer and copy paste the code in `app.coffee`. Note that you will still need to use your own access token. 

- [Create a simple map view](https://github.com/mapbox/framer-example/tree/master/simple-map-view)
- [Update data in real time](https://github.com/mapbox/framer-example/tree/master/dataset-api)

<img src="https://user-images.githubusercontent.com/5186564/27195034-06eb4722-51d3-11e7-828f-2d69752980f8.gif" />
