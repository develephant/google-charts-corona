# Google Charts Module

__Display [Google Charts](https://google-developers.appspot.com/chart/) as non-interactive static images in Corona.__

![chart1](imgs/chart1.png)

## Overview

This module extracts the PNG data from a locally stored Google Charts HTML page and returns it to Corona using the Google Charts API `getImageURI()` method.

The ability to get an image of a chart is limited to the __corecharts__ and __geomap__ types only. For an overview of the charts supported see the _demo/charts_ directory.

## Setup

You will first need to create the proper HTML page with the Google Chart you want to render. See the [Google Charts API]() for more information on how to do that.

Once you have your chart HTML, you will need to add the following JavaScript listener direcly before the `chart.draw()` method (See the examples in the _demo/charts_ directory).

```js
//This listener is required to call Corona
google.visualization.events.addListener(chart, 'ready', function() {
  //Return image data to Corona
  window.location.assign("content://chart?png="+chart.getImageURI());
});
```

Once you've added the listener code, store the HTML file in a local directory in your Corona project.

## API

To use the module in your Corona project, add the module to the root of the project and require it:

```lua
local chart = require("google_charts")
```

### Methods

#### get

Load a local Google Chart HTML file and extract the PNG data.

```lua
chart.get(chart_html, chart_dir, dest_file, dest_dir, listener)
```

__Parameters__

|Name|Description|Type|Required|
|----|-----------|----|--------|
|chart_html|The pathname of the chart HTML file that should be rendered to a PNG.|_String_|__Y__|
|chart_dir|The Corona system directory the file resides in. If you pass `nil` for this parameter then __system.ResourceDirectory__ is used.|_Const_|__Y__|
|dest_file|The pathname of the chart PNG that is returned from the chart HTML.|_String_|__Y__|
|dest_dir|The Corona system directory the file resides in. If you pass `nil` for this parameter then __system.DocumentsDirectory__ is used.|_Const_|__Y__|
|listener|The event listener function that will recieve the PNG properties when finished downloading (see below).|_Function_|__Y__|

__Listener__

The event listener will return the results from the get method. It looks like:

```lua
local function onGetChart( event )
  if event.error then
    print(event.error)
  else
    print(event.filename, event.baseDir)
  end
end
```

The `event.filename` and `event.baseDir` should be passed to a Coronium `display.newImage` method (or similar) for display.

## Usage

__Corona Example__

```lua
-- Require the module
local chart = require("google_charts")

-- Create a display handler
local function displayChart(filename, baseDir)
  display.newImage(filename, baseDir, display.contentCenterX, display.contentCenterY)
end

-- Create the chart listener
local function onGetChart( event )
  if event.error then
    print(event.error)
  else
    displayChart(event.filename, event.baseDir)
  end
end

-- Request image for `charts/donut.html` in system.ResourceDirectory
chart.get("charts/donut.html", nil, "chart.png", nil, onGetChart)
```

__charts/donut.html__

```html
<html>
  <head>
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript">
      google.charts.load("current", {packages:["corechart"]});
      google.charts.setOnLoadCallback(drawChart);
      function drawChart() {
        var data = google.visualization.arrayToDataTable([
          ['Task', 'Hours per Day'],
          ['Work',     11],
          ['Eat',      2],
          ['Commute',  2],
          ['Watch TV', 2],
          ['Sleep',    7]
        ]);

        var options = {
          title: 'My Daily Activities',
          pieHole: 0.4,
        };

        var chart = new google.visualization.PieChart(document.getElementById('donutchart'));

        //----------------------------------------------------------------------
        // You must add this listener to the Google Chart HTML before the 
        // chart.draw() method to retrieve the PNG image.
        //----------------------------------------------------------------------
        google.visualization.events.addListener(chart, 'ready', function() {
          //Return image data to Corona
          window.location.assign("content://chart?png="+chart.getImageURI());
        });
        //----------------------------------------------------------------------

        chart.draw(data, options);
      }
    </script>
  </head>
  <body>
    <!-- On most charts the width and height adjust the output size -->
    <div id="donutchart" style="width: 900px; height: 500px;"></div>
  </body>
</html>
```

