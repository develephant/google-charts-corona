--=============================================================================
-- Google Chart Module
-- Returns a PNG from an HTML page with Google Chart API Javascript
-- https://developers.google.com/chart/
-- (c)2018 C. Byerley (develephant)
--=============================================================================
local mime = require('mime')

--=============================================================================
-- Utils
--=============================================================================
local function split( inputstr, sep )
  if sep == nil then
    sep = "%s"
  end
  local t={} ; i=1
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    t[i] = str
    i = i + 1
  end
  return t
end

--=============================================================================
-- Module
--=============================================================================
local chart = {}

function chart.get( chartHtml, chartDir, destFile, destDir, listener )

  if type(chartHtml) == 'table' then
    local tbl = chartHtml

    chart_html = tbl.chart_html
    chart_dir = tbl.chart_dir or system.ResourceDirectory
    dest_file = tbl.dest_file
    dest_dir = tbl.dest_dir or system.DocumentsDirectory

    listener = chartDir
  else
    chart_html = chartHtml
    chart_dir = chartDir or system.ResourceDirectory
    dest_file = destFile
    dest_dir = destDir or system.DocumentsDirectory
  end

  assert(listener, "An event listener is required.")

  local webView

  local function _processPng( dest_file, dest_dir, b64_encoded )
    local b64_decoded = mime.unb64( b64_encoded )
    local path = system.pathForFile( dest_file, dest_dir )
    local file = io.open( path, 'wb' )
    file:write( b64_decoded )
    file:close()
    file = nil
  
    return path
  end

  local function webListener( event )

    if event.errorCode then
      return listener({ error = event.errorMessage })
    end
      if event.url and string.find(event.url, "#data:image") then
        webView:stop()
        webView:removeSelf()
        local b64_encoded = split(event.url, ",")[2]
        local file_path = _processPng( dest_file, dest_dir, b64_encoded )
        return listener({ filename = dest_file, baseDir = dest_dir })
      end
  end
  
  webView = native.newWebView( display.contentCenterX, -1000, 320, 480 )
  webView.isVisible = false

  webView:request( chart_html, chart_dir )
  
  webView:addEventListener( "urlRequest", webListener )
end

return chart