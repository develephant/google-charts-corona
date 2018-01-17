# Google Charts Module

__Display [Google Charts](https://google-developers.appspot.com/chart/) as static images in Corona.__

![chart1](imgs/chart1.png)

_Note: This module only displays static PNGs. There is no interactivity available on the charts._


chart.get("charts/scatter.html", nil, "chart.png", nil, chartListener)

-- chart.get({
--   chart_html = "charts/bubble.html",
--   chart_dir = system.ResourceDirectory,
--   dest_file = "chart.png",
--   dest_dir = system.DocumentsDirectory
-- }, chartListener)