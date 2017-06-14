viewlib = require './view.coffee'
drawlib = require './draw.coffee'
helper = require './helper.coffee'
modes = require './modes.coffee'

modeOptions = {}

###
bigSvg = document.createElementNS helper.SVG_STANDARD, 'svg'
document.body.appendChild bigSvg
bigSvg.style.width = '500px'
bigSvg.style.height = '500px'
draw = new drawlib.Draw(bigSvg)
path = new draw.Path([
  new draw.Point 0, 0
  new draw.Point 100, 0
  new draw.Point 100, 100
  new draw.Point 0, 100
], true, {
  fillColor: '#AAF'
})
path.update()
###

exports.setModeOptions = (language, options) ->
  modeOptions[language] = options

exports.highlight = ->
  FILTER_SVG = '''
  <svg width=0 height=0>
    <filter id="droplet-path-bevel" filterUnits="objectBoundingBox" x="-10%" y="-10%" width="150%" height="150%">
      <feGaussianBlur in="SourceAlpha" stdDeviation="3" result="interim"/>
      <feComponentTransfer in="interim" out="blur">
        <feFuncA type="linear" slope="1.3" intercept="0">
      </feComponentTransfer>
      <feDiffuseLighting in="blur" surfaceScale="5" specularConstant="0.5" specularExponent="10" result="specOut">
        <feDistantLight azimuth="225" elevation="45"/>
      </feDiffuseLighting>
      <feComposite in="specOut" in2="SourceAlpha" operator="in" result="specOut2"/>
      <feComposite in="SourceGraphic" in2="specOut2" operator="arithmetic" k1="1.4" k2="0" k3="0" k4="0" result="litPaint" />
    </filter>

  </svg>
  '''

  div = document.createElement 'div'
  div.innerHTML = FILTER_SVG
  document.body.appendChild div

  replaceElement = (element) ->
    language = element.getAttribute 'droplet-lang'
    mode = new modes[language](modeOptions[language])

    dropletDocument = mode.parse element.innerText.trim()
    dropletDocument.opts.roundedSingletons = true

    svg = document.createElementNS 'http://www.w3.org/2000/svg', 'svg'

    view = new viewlib.View(svg)
    node = view.getViewNodeFor(dropletDocument)
    node.layout 0, 0
    svg.style.width = node.totalBounds.width + 'px'
    svg.style.height = node.totalBounds.height + 'px'
    node.draw()

    element.innerHTML = ''
    element.appendChild svg

  for el, i in document.getElementsByTagName('pre')
    if el.hasAttribute('droplet-lang')
      replaceElement el

window.addEventListener 'load', ->
  exports.highlight()
