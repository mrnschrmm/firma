var _paq = window._paq || []
_paq.push(['trackPageView'])
_paq.push(['enableLinkTracking']);

(function () {
  var u = 'https://www.schramm-reinigung.de/metrics/'
  _paq.push(['setTrackerUrl', u + 'matomo.php'])
  _paq.push(['setSiteId', '1'])
  var d = document
  var g = d.createElement('script')
  var s = d.getElementsByTagName('script')[0]
  g.type = 'text/javascript'
  g.async = true
  g.defer = true
  g.src = u + 'matomo.js'
  s.parentNode.insertBefore(g, s)
})()
