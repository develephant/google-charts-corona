--=============================================================================
-- Google Charts Module Demo
-- Returns a PNG from an HTML page with Google Chart API Javascript
-- https://developers.google.com/chart/
-- (c)2018 C. Byerley (develephant)
--=============================================================================

-- Include Module
local chart = require("google_charts")

-- Display Handler
local function displayChart( filename, baseDir )
  display.newImage( filename, baseDir, display.contentCenterX, display.contentCenterY )
end

-- Chart Listener
local function chartListener( evt )
  if evt.error then
    print(evt.error)
  else
    displayChart( evt.filename, evt.baseDir )
  end
end

-- Request Chart Image
chart.get("charts/bubble.html", system.ResourceDirectory, "chart.png", system.DocumentsDirectory, chartListener)

