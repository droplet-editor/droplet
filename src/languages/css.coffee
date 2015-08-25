helper = require '../helper.coffee'
model = require '../model.coffee'
parser = require '../parser.coffee'

parserlib = require '../../vendor/node-parserlib.js'

NODES = {
  # Rules and related
  rule: {color: 'orange'}
  selector: {color: 'green'}
  'selector-modifier': {color: 'lightblue'}
  property: {color: 'amber'}
  'property-value': {color: 'teal'}
  'property-part': {color: 'indigo'}

  # Single line commands
  charset: {color: 'yellow'}
  namespace: {color: 'yellow'}
  import: {color: 'yellow'}

  # @ Rules
  fontface: {color: 'purple'}
  viewport: {color: 'purple'}
  keyframes: {color: 'purple'}
  keyframerule: {color: 'blue'}
  page: {color: 'purple'}
  pagemargin: {color: 'blue'}
  mediaquery: {color: 'purple'}

  # Default fallback
  Default: {color: 'cyan'}
}

# Not currently in use but intend
# to use it later for categorizing
# properties and colouring them accordingly.
PROPERTIES = {

  "align-items"                   : {category: 'box-flexible'},
  "align-content"                 : {category: 'box-flexible'},
  "align-self"                    : {category: 'box-flexible'},
  "-webkit-align-items"           : {category: 'box-flexible'},
  "-webkit-align-content"         : {category: 'box-flexible'},
  "-webkit-align-self"            : {category: 'box-flexible'},
  "alignment-adjust"              : "auto | baseline | before-edge | text-before-edge | middle | central | after-edge | text-after-edge | ideographic | alphabetic | hanging | mathematical | <percentage> | <length>",
  "alignment-baseline"            : "baseline | use-script | before-edge | text-before-edge | after-edge | text-after-edge | central | middle | ideographic | alphabetic | hanging | mathematical",
  "animation"                     : 1,
  "animation-delay"               : { multi: "<time>", comma: true },
  "animation-direction"           : { multi: "normal | alternate", comma: true },
  "animation-duration"            : { multi: "<time>", comma: true },
  "animation-fill-mode"           : { multi: "none | forwards | backwards | both", comma: true },
  "animation-iteration-count"     : { multi: "<number> | infinite", comma: true },
  "animation-name"                : { multi: "none | <ident>", comma: true },
  "animation-play-state"          : { multi: "running | paused", comma: true },
  "animation-timing-function"     : 1,

  "-moz-animation-delay"               : { multi: "<time>", comma: true },
  "-moz-animation-direction"           : { multi: "normal | alternate", comma: true },
  "-moz-animation-duration"            : { multi: "<time>", comma: true },
  "-moz-animation-iteration-count"     : { multi: "<number> | infinite", comma: true },
  "-moz-animation-name"                : { multi: "none | <ident>", comma: true },
  "-moz-animation-play-state"          : { multi: "running | paused", comma: true },

  "-ms-animation-delay"               : { multi: "<time>", comma: true },
  "-ms-animation-direction"           : { multi: "normal | alternate", comma: true },
  "-ms-animation-duration"            : { multi: "<time>", comma: true },
  "-ms-animation-iteration-count"     : { multi: "<number> | infinite", comma: true },
  "-ms-animation-name"                : { multi: "none | <ident>", comma: true },
  "-ms-animation-play-state"          : { multi: "running | paused", comma: true },

  "-webkit-animation-delay"               : { multi: "<time>", comma: true },
  "-webkit-animation-direction"           : { multi: "normal | alternate", comma: true },
  "-webkit-animation-duration"            : { multi: "<time>", comma: true },
  "-webkit-animation-fill-mode"           : { multi: "none | forwards | backwards | both", comma: true },
  "-webkit-animation-iteration-count"     : { multi: "<number> | infinite", comma: true },
  "-webkit-animation-name"                : { multi: "none | <ident>", comma: true },
  "-webkit-animation-play-state"          : { multi: "running | paused", comma: true },

  "-o-animation-delay"               : { multi: "<time>", comma: true },
  "-o-animation-direction"           : { multi: "normal | alternate", comma: true },
  "-o-animation-duration"            : { multi: "<time>", comma: true },
  "-o-animation-iteration-count"     : { multi: "<number> | infinite", comma: true },
  "-o-animation-name"                : { multi: "none | <ident>", comma: true },
  "-o-animation-play-state"          : { multi: "running | paused", comma: true },

  "appearance"                    : "icon | window | desktop | workspace | document | tooltip | dialog | button | push-button | hyperlink | radio-button | checkbox | menu-item | tab | menu | menubar | pull-down-menu | pop-up-menu | list-menu | radio-group | checkbox-group | outline-tree | range | field | combo-box | signature | password | normal | none | inherit",
  "azimuth"                       : ''


  "backface-visibility"           : "visible | hidden",
  "background"                    : {category: 'background'},
  "background-attachment"         : {category: 'background'},
  "background-clip"               : {category: 'background'},
  "background-color"              : {category: 'background'},
  "background-image"              : {category: 'background'},
  "background-origin"             : {category: 'background'},
  "background-position"           : {category: 'background'},
  "background-repeat"             : {category: 'background'},
  "background-size"               : {category: 'background'},
  "baseline-shift"                : "baseline | sub | super | <percentage> | <length>",
  "behavior"                      : 1,
  "binding"                       : 1,
  "bleed"                         : "<length>",
  "bookmark-label"                : "<content> | <attr> | <string>",
  "bookmark-level"                : "none | <integer>",
  "bookmark-state"                : "open | closed",
  "bookmark-target"               : "none | <uri> | <attr>",
  "border"                        : {category: 'border'},
  "border-bottom"                 : {category: 'border'},
  "border-bottom-color"           : {category: 'border'},
  "border-bottom-left-radius"     : {category: 'border'},
  "border-bottom-right-radius"    : {category: 'border'},
  "border-bottom-style"           : {category: 'border'},
  "border-bottom-width"           : {category: 'border'},
  "border-collapse"               : {category: 'table'},
  "border-color"                  : {category: 'border'},
  "border-image"                  : {category: 'border'},
  "border-image-outset"           : {category: 'border'},
  "border-image-repeat"           : {category: 'border'},
  "border-image-slice"            : {category: 'border'},
  "border-image-source"           : {category: 'border'},
  "border-image-width"            : {category: 'border'},
  "border-left"                   : {category: 'border'},
  "border-left-color"             : {category: 'border'},
  "border-left-style"             : {category: 'border'},
  "border-left-width"             : {category: 'border'},
  "border-radius"                 : {category: 'border'},
  "border-right"                  : {category: 'border'},
  "border-right-color"            : {category: 'border'},
  "border-right-style"            : {category: 'border'},
  "border-right-width"            : {category: 'border'},
  "border-spacing"                : {category: 'table'},
  "border-style"                  : {category: 'border'},
  "border-top"                    : {category: 'border'},
  "border-top-color"              : {category: 'border'},
  "border-top-left-radius"        : {category: 'border'},
  "border-top-right-radius"       : {category: 'border'},
  "border-top-style"              : {category: 'border'},
  "border-top-width"              : {category: 'border'},
  "border-width"                  : {category: 'border'},
  "bottom"                        : {category: 'box-basic'},
  "-moz-box-align"                : "start | end | center | baseline | stretch",
  "-moz-box-decoration-break"     : {category: 'border'},
  "-moz-box-direction"            : "normal | reverse | inherit",
  "-moz-box-flex"                 : "<number>",
  "-moz-box-flex-group"           : "<integer>",
  "-moz-box-lines"                : "single | multiple",
  "-moz-box-ordinal-group"        : "<integer>",
  "-moz-box-orient"               : "horizontal | vertical | inline-axis | block-axis | inherit",
  "-moz-box-pack"                 : "start | end | center | justify",
  "-webkit-box-align"             : "start | end | center | baseline | stretch",
  "-webkit-box-decoration-break"  : {category: 'border'},
  "-webkit-box-direction"         : "normal | reverse | inherit",
  "-webkit-box-flex"              : "<number>",
  "-webkit-box-flex-group"        : "<integer>",
  "-webkit-box-lines"             : "single | multiple",
  "-webkit-box-ordinal-group"     : "<integer>",
  "-webkit-box-orient"            : "horizontal | vertical | inline-axis | block-axis | inherit",
  "-webkit-box-pack"              : "start | end | center | justify",
  "box-shadow"                    : {category: 'border'},
  "box-sizing"                    : "content-box | border-box | inherit",
  "break-after"                   : "auto | always | avoid | left | right | page | column | avoid-page | avoid-column",
  "break-before"                  : "auto | always | avoid | left | right | page | column | avoid-page | avoid-column",
  "break-inside"                  : "auto | avoid | avoid-page | avoid-column",


  "caption-side"                  : {category: 'table'},
  "clear"                         : {category: 'box-basic'},
  "clip"                          : {category: 'box-basic'},
  'color'                         : {category: 'color'},
  "color-profile"                 : 1,
  "column-count"                  : "<integer> | auto",
  "column-fill"                   : "auto | balance",
  "column-gap"                    : "<length> | normal",
  "column-rule"                   : "<border-width> || <border-style> || <color>",
  "column-rule-color"             : "<color>",
  "column-rule-style"             : "<border-style>",
  "column-rule-width"             : "<border-width>",
  "column-span"                   : "none | all",
  "column-width"                  : "<length> | auto",
  "columns"                       : 1,
  "content"                       : 1,
  "counter-increment"             : 1,
  "counter-reset"                 : 1,
  "crop"                          : "<shape> | auto",
  "cue"                           : "cue-after | cue-before | inherit",
  "cue-after"                     : 1,
  "cue-before"                    : 1,
  "cursor"                        : 1,


  "direction"                     : {category: 'writing-mode'},
  "display"                       : {category: 'box-basic'},
  "dominant-baseline"             : 1,
  "drop-initial-after-adjust"     : "central | middle | after-edge | text-after-edge | ideographic | alphabetic | mathematical | <percentage> | <length>",
  "drop-initial-after-align"      : "baseline | use-script | before-edge | text-before-edge | after-edge | text-after-edge | central | middle | ideographic | alphabetic | hanging | mathematical",
  "drop-initial-before-adjust"    : "before-edge | text-before-edge | central | middle | hanging | mathematical | <percentage> | <length>",
  "drop-initial-before-align"     : "caps-height | baseline | use-script | before-edge | text-before-edge | after-edge | text-after-edge | central | middle | ideographic | alphabetic | hanging | mathematical",
  "drop-initial-size"             : "auto | line | <length> | <percentage>",
  "drop-initial-value"            : "initial | <integer>",


  "elevation"                     : "<angle> | below | level | above | higher | lower | inherit",
  "empty-cells"                   : {category: 'table'},


  "filter"                        : 1,
  "fit"                           : "fill | hidden | meet | slice",
  "fit-position"                  : 1,
  "flex"                          : {category: 'box-flexible'},
  "flex-basis"                    : {category: 'box-flexible'},
  "flex-direction"                : {category: 'box-flexible'},
  "flex-flow"                     : {category: 'box-flexible'},
  "flex-grow"                     : {category: 'box-flexible'},
  "flex-shrink"                   : {category: 'box-flexible'},
  "flex-wrap"                     : {category: 'box-flexible'},
  "-webkit-flex"                  : {category: 'box-flexible'},
  "-webkit-flex-basis"            : {category: 'box-flexible'},
  "-webkit-flex-direction"        : {category: 'box-flexible'},
  "-webkit-flex-flow"             : {category: 'box-flexible'},
  "-webkit-flex-grow"             : {category: 'box-flexible'},
  "-webkit-flex-shrink"           : {category: 'box-flexible'},
  "-webkit-flex-wrap"             : {category: 'box-flexible'},
  "-ms-flex"                      : {category: 'box-flexible'},
  "-ms-flex-align"                : {category: 'box-flexible'},
  "-ms-flex-direction"            : {category: 'box-flexible'},
  "-ms-flex-order"                : {category: 'box-flexible'},
  "-ms-flex-pack"                 : {category: 'box-flexible'},
  "-ms-flex-wrap"                 : {category: 'box-flexible'},
  "float"                         : {category: 'box-basic'},
  "float-offset"                  : 1,
  "font"                          : {category: 'font'},
  "font-family"                   : {category: 'font'},
  "font-size"                     : {category: 'font'},
  "font-size-adjust"              : {category: 'font'},
  "font-stretch"                  : {category: 'font'},
  "font-style"                    : {category: 'font'},
  "font-variant"                  : {category: 'font'},
  "font-weight"                   : {category: 'font'},


  "grid-cell-stacking"            : "columns | rows | layer",
  "grid-column"                   : 1,
  "grid-columns"                  : 1,
  "grid-column-align"             : "start | end | center | stretch",
  "grid-column-sizing"            : 1,
  "grid-column-span"              : "<integer>",
  "grid-flow"                     : "none | rows | columns",
  "grid-layer"                    : "<integer>",
  "grid-row"                      : 1,
  "grid-rows"                     : 1,
  "grid-row-align"                : "start | end | center | stretch",
  "grid-row-span"                 : "<integer>",
  "grid-row-sizing"               : 1,


  "hanging-punctuation"           : {category: 'text'},
  "height"                        : {category: 'box-basic'},
  "hyphenate-after"               : "<integer> | auto",
  "hyphenate-before"              : "<integer> | auto",
  "hyphenate-character"           : "<string> | auto",
  "hyphenate-lines"               : "no-limit | <integer>",
  "hyphenate-resource"            : 1,
  "hyphens"                       : {category: 'text'},


  "icon"                          : 1,
  "image-orientation"             : "angle | auto",
  "image-rendering"               : 1,
  "image-resolution"              : 1,
  "inline-box-align"              : "initial | last | <integer>",


  "justify-content"               : {category: 'box-flexible'},
  "-webkit-justify-content"       : {category: 'box-flexible'},


  "left"                          : {category: 'box-basic'},
  "letter-spacing"                : {category: 'text'},
  "line-height"                   : {category: 'text'},
  "line-break"                    : {category: 'text'},
  "line-stacking"                 : 1,
  "line-stacking-ruby"            : "exclude-ruby | include-ruby",
  "line-stacking-shift"           : "consider-shifts | disregard-shifts",
  "line-stacking-strategy"        : "inline-line-height | block-line-height | max-height | grid-height",
  "list-style"                    : 1,
  "list-style-image"              : "<uri> | none | inherit",
  "list-style-position"           : "inside | outside | inherit",
  "list-style-type"               : "disc | circle | square | decimal | decimal-leading-zero | lower-roman | upper-roman | lower-greek | lower-latin | upper-latin | armenian | georgian | lower-alpha | upper-alpha | none | inherit",


  "margin"                        : {category: 'box-basic'},
  "margin-bottom"                 : {category: 'box-basic'},
  "margin-left"                   : {category: 'box-basic'},
  "margin-right"                  : {category: 'box-basic'},
  "margin-top"                    : {category: 'box-basic'},
  "mark"                          : 1,
  "mark-after"                    : 1,
  "mark-before"                   : 1,
  "marks"                         : 1,
  "marquee-direction"             : 1,
  "marquee-play-count"            : 1,
  "marquee-speed"                 : 1,
  "marquee-style"                 : 1,
  "max-height"                    : {category: 'box-basic'},
  "max-width"                     : {category: 'box-basic'},
  "min-height"                    : {category: 'box-basic'},
  "min-width"                     : {category: 'box-basic'},
  "move-to"                       : 1,


  "nav-down"                      : 1,
  "nav-index"                     : 1,
  "nav-left"                      : 1,
  "nav-right"                     : 1,
  "nav-up"                        : 1,


  'opacity'                       : {category: 'color'},
  "order"                         : {category: 'box-flexible'},
  "-webkit-order"                 : {category: 'box-flexible'},
  "orphans"                       : "<integer> | inherit",
  "outline"                       : 1,
  "outline-color"                 : "<color> | invert | inherit",
  "outline-offset"                : 1,
  "outline-style"                 : "<border-style> | inherit",
  "outline-width"                 : "<border-width> | inherit",
  "overflow"                      : {category: 'box-basic'},
  "overflow-style"                : 1,
  "overflow-wrap"                 : {category: 'text'},
  "overflow-x"                    : {category: 'box-basic'},
  "overflow-y"                    : {category: 'box-basic'},


  "padding"                       : {category: 'box-basic'},
  "padding-bottom"                : {category: 'box-basic'},
  "padding-left"                  : {category: 'box-basic'},
  "padding-right"                 : {category: 'box-basic'},
  "padding-top"                   : {category: 'box-basic'},
  "page"                          : 1,
  "page-break-after"              : "auto | always | avoid | left | right | inherit",
  "page-break-before"             : "auto | always | avoid | left | right | inherit",
  "page-break-inside"             : "auto | avoid | inherit",
  "page-policy"                   : 1,
  "pause"                         : 1,
  "pause-after"                   : 1,
  "pause-before"                  : 1,
  "perspective"                   : 1,
  "perspective-origin"            : 1,
  "phonemes"                      : 1,
  "pitch"                         : 1,
  "pitch-range"                   : 1,
  "play-during"                   : 1,
  "pointer-events"                : "auto | none | visiblePainted | visibleFill | visibleStroke | visible | painted | fill | stroke | all | inherit",
  "position"                      : {category: 'box-basic'},
  "presentation-level"            : 1,
  "punctuation-trim"              : 1,


  "quotes"                        : 1,


  "rendering-intent"              : 1,
  "resize"                        : 1,
  "rest"                          : 1,
  "rest-after"                    : 1,
  "rest-before"                   : 1,
  "richness"                      : 1,
  "right"                         : {category: 'box-basic'},
  "rotation"                      : 1,
  "rotation-point"                : 1,
  "ruby-align"                    : 1,
  "ruby-overhang"                 : 1,
  "ruby-position"                 : 1,
  "ruby-span"                     : 1,


  "size"                          : 1,
  "speak"                         : "normal | none | spell-out | inherit",
  "speak-header"                  : "once | always | inherit",
  "speak-numeral"                 : "digits | continuous | inherit",
  "speak-punctuation"             : "code | none | inherit",
  "speech-rate"                   : 1,
  "src"                           : 1,
  "stress"                        : 1,
  "string-set"                    : 1,

  "table-layout"                  : {category: 'table'},
  "tab-size"                      : {category: 'text'},
  "target"                        : 1,
  "target-name"                   : 1,
  "target-new"                    : 1,
  "target-position"               : 1,
  "text-align"                    : {category: 'text'},
  "text-align-last"               : {category: 'text'},
  "text-decoration"               : {category: 'text'},
  "text-emphasis"                 : {category: 'text'},
  "text-height"                   : {category: 'text'},
  "text-indent"                   : {category: 'text'},
  "text-justify"                  : {category: 'text'},
  "text-outline"                  : {category: 'text'},
  "text-overflow"                 : {category: 'text'},
  "text-rendering"                : {category: 'text'},
  "text-shadow"                   : {category: 'text'},
  "text-transform"                : {category: 'text'},
  "text-wrap"                     : {category: 'text'},
  "top"                           : {category: 'box-basic'},
  "-ms-touch-action"              : "auto | none | pan-x | pan-y",
  "touch-action"                  : "auto | none | pan-x | pan-y",
  "transform"                     : 1,
  "transform-origin"              : 1,
  "transform-style"               : 1,
  "transition"                    : 1,
  "transition-delay"              : 1,
  "transition-duration"           : 1,
  "transition-property"           : 1,
  "transition-timing-function"    : 1,


  "unicode-bidi"                  : {category: 'writing-mode'},
  "user-modify"                   : "read-only | read-write | write-only | inherit",
  "user-select"                   : "none | text | toggle | element | elements | all | inherit",


  "vertical-align"                : {category: 'box-basic'},
  "visibility"                    : {category: 'box-basic'},
  "voice-balance"                 : 1,
  "voice-duration"                : 1,
  "voice-family"                  : 1,
  "voice-pitch"                   : 1,
  "voice-pitch-range"             : 1,
  "voice-rate"                    : 1,
  "voice-stress"                  : 1,
  "voice-volume"                  : 1,
  "volume"                        : 1,


  "white-space"                   : {category: 'text'},
  "white-space-collapse"          : 1,
  "widows"                        : "<integer> | inherit",
  "width"                         : {category: 'box-basic'},
  "word-break"                    : {category: 'text'},
  "word-spacing"                  : {category: 'text'},
  "word-wrap"                     : {category: 'text'},
  "writing-mode"                  : {category: 'writing-mode'},


  "z-index"                       : {category: 'box-basic'},
  "zoom"                          : "<number> | <percentage> | normal"
}

DEFAULT_INDENT_DEPTH = '  '

PARSE_CONTEXTS = {
  selector: 'parseSelector'
  'selector-modifier': 'parseSelectorSubPart'
  property: 'parseStyleAttribute'
  'property-value': 'parsePropertyValue'
  'property-part': 'parsePropertyValue'
}

UNITS = {
  length: ['em', 'px', 'mm', 'in', 'pt']
  angle: ['deg', 'rad', 'grad']
  time: ['ms', 's']
  frequency: ['hz', 'khz']
  resolution: ['dpi', 'dpcm']
  pseudoElements: ['before', 'after', 'first-letter', 'first-line', 'selection']
  pseudoClasses: ['active', 'hover', 'link', 'focus', 'visited']
}

PROPERTY_CONTAINING = ['page', 'pagemargin', 'fontface', 'viewport', 'rule', 'keyframerule']

Stack = []
Stack.setValid = (state) -> Stack._valid = state
Stack.getValid = -> return (Stack._valid is true)
Stack.init = ->
  Stack.length = 0
  Stack.start {}, 'stylesheet'
Stack.top = -> return Stack[Stack.length - 1]
Stack.add = (element, type) ->
  element.nodeType = type
  Stack.top().children.push element
Stack.start = (element, type) ->
  element.nodeType = type
  element.children = []
  Stack.push element
Stack.end = (element) ->
  top = Stack.top()
  Stack.pop()
  top.loc.content = {}
  top.loc.content.startLine = top.loc.endLine
  top.loc.content.startCol = top.loc.endCol
  top.loc.endLine = element.loc.line
  top.loc.endCol = element.loc.col
  top.loc.content.endLine = top.loc.endLine
  top.loc.content.endCol = top.loc.endCol - 1
  Stack.add top, top.nodeType

cssParser = new parserlib.css.Parser()
cssParser.addListener("startstylesheet", -> null)
cssParser.addListener("endstylesheet", -> null)
cssParser.addListener("charset", (event) -> Stack.add event, 'charset')
cssParser.addListener("namespace", (event) ->  Stack.add event, 'namespace')
cssParser.addListener("startfontface", (event) -> Stack.start event, 'fontface')
cssParser.addListener("endfontface", (event) -> Stack.end event)
cssParser.addListener("startviewport", (event) -> Stack.start event, 'viewport')
cssParser.addListener("endviewport", (event) -> Stack.end event)
cssParser.addListener("startkeyframes", (event) -> Stack.start event, 'keyframes')
cssParser.addListener("startkeyframerule", (event) -> Stack.start event, 'keyframerule')
cssParser.addListener("endkeyframerule", (event) -> Stack.end event)
cssParser.addListener("endkeyframes", (event) -> Stack.end event)
cssParser.addListener("startpage", (event) -> Stack.start event, 'page')
cssParser.addListener("endpage", (event) -> Stack.end event)
cssParser.addListener("startpagemargin", (event) -> Stack.start event, 'pagemargin')
cssParser.addListener("endpagemargin", (event) -> Stack.end event)
cssParser.addListener("import", (event) -> Stack.add event, 'import')
cssParser.addListener("startrule", (event) -> Stack.start event, 'rule')
cssParser.addListener("endrule", (event) -> Stack.end event)
cssParser.addListener("property", (event) -> Stack.add event, 'property')
cssParser.addListener("startmedia", (event) -> Stack.start event, 'mediaquery')
cssParser.addListener("endmedia", (event) -> Stack.end event)
cssParser.addListener("error", (event) -> Stack.setValid false)

# Though we are not parsing style Attribute
# it is the same as parsing a set of declarations
# and we use it to parse a single declaration
ParseOrder = ["parse", "parseSelectorSubPart", "parseSelector", "parsePropertyValue", "parseMediaQuery", "parseStyleAttribute"]

exports.CSSParser = class CSSParser extends parser.Parser

  constructor: (@text, @opts = {}) ->
    super

    @opts.nodes = helper.extend({}, NODES, @opts.nodes)

    @lines = @text.split '\n'

  getAcceptsRule: (node) -> default: helper.NORMAL

  getPrecedence: (node) -> 1

  getClasses: (node, type) ->
    classes = [type || node.nodeType || "unknown"]
    if node.nodeType is 'property'
      bounds = @getBounds node
      if @lines[bounds.end.line][bounds.end.column - 1] isnt ';'
        classes = classes.concat 'no-semicolon'
    return classes

  getColor: (node) -> @opts.nodes[node.nodeType]?.color ? @opts.nodes.Default.color

  getBounds: (node) ->
    bounds = {
      start: {
        line: node.loc.startLine - 1
        column: node.loc.startCol - 1
      }
      end: {
        line: node.loc.endLine - 1
        column: node.loc.endCol - 1
      }
    }

    return bounds

  getSocketLevel: (node) -> helper.ANY_DROP

  getPropertyChoices: (node) ->
    str = parserlib.css.Properties[node.property.text]
    if typeof str is 'string'
      types = str.split('|').map((x)->x.trim()).filter((x)->x.length isnt 0 and x[0] isnt '-')
      lst = types.filter((x)->x[0]!='<')
      if lst.length > 0
        console.log lst
        lst.dropdownOnly = types.length is lst.length
        return lst
    return null

  cssBlock: (node, depth) ->
    if not node
      return
    @addBlock
      bounds: @getBounds node
      depth: depth
      precedence: @getPrecedence node
      color: @getColor node
      classes: @getClasses node
      socketLevel: @getSocketLevel node
      parseContext: node.nodeType

  cssSocket: (node, depth, precedence, bounds, dropdown, type) ->
    if not node
      return
    empty = ''
    switch node.nodeType
      when 'selector'
        empty = '__'
      when 'selector-modifier'
        empty = '__'
      when 'property-value'
        empty = '__'
      when 'property-part'
        empty = '__'
    @addSocket
      bounds: bounds ? @getBounds node
      depth: depth
      precedence: precedence ? @getPrecedence node
      classes: @getClasses node, type
      acccepts: @getAcceptsRule node
      dropdown: dropdown
      empty: empty
      parseContext: node.nodeType

  getIndentPrefix: (bounds, indentDepth) ->
    if bounds.end.line - bounds.start.line < 1
      return DEFAULT_INDENT_DEPTH
    else
      line = @lines[bounds.start.line + 1]
      return line[indentDepth...(line.length - line.trimLeft().length)]

  getIndentBounds: (node) ->
    bounds = {
      start: {
        line: node.loc.content.startLine - 1
        column: node.loc.content.startCol - 1
      }
      end: {
        line: node.loc.content.endLine - 1
        column: node.loc.content.endCol - 1
      }
    }

    if @lines[bounds.end.line][...bounds.end.column].trim().length is 0
      bounds.end.line--
      bounds.end.column = @lines[bounds.end.line].length

    return bounds

  nameTree: (node) ->
    if not node
      return

    unless node.nodeType
      if node instanceof parserlib.css.Selector
        node.nodeType = 'selector'
      else if node instanceof parserlib.css.SelectorPart
        node.nodeType = 'selector-part'
      else if node instanceof parserlib.css.SelectorSubPart
        if node.type is 'elementName'
          node.nodeType = 'selector-elementname'
        else
          node.nodeType = 'selector-modifier'
      else if node instanceof parserlib.css.PropertyValue
        node.nodeType = 'property-value'
      else if node instanceof parserlib.css.PropertyValuePart
        node.nodeType = 'property-part'
      else if node instanceof parserlib.css.MediaQuery
        node.nodeType = 'media'

    switch node.nodeType
      when 'keyframerule'
        for key in node.keys
          key.nodeType = 'key'
      when 'rule'
        for sel in node.selectors
          @nameTree sel
      when 'selector'
        for part in node.parts
          @nameTree part
      when 'selector-part'
        for mod in node.modifiers
          @nameTree mod
        @nameTree node.elementName
      when 'property'
        @nameTree node.value
      when 'property-value'
        for part in node.parts
          @nameTree part
      when 'property-part'
        @nameTree node.args

    if node.children?
      for child in node.children
        @nameTree child

  markRoot: ->
    ast = null
    parseContext = PARSE_CONTEXTS[@opts.parseOptions?.context]
    # Required because 'selector' parse
    # preference is higher than 'property'
    # The other way round would also require some if-elses (probably more than this)
    if parseContext
      # Reparse property-value as property-value instead of selector
      if @opts.parseOptions.context in ['selector', 'selector-part'] and @opts.parseOptions.parentContext is 'property'
        parseContext = PARSE_CONTEXTS['property-value']
      Stack.init()
      Stack.setValid true
      ast = cssParser[parseContext] @text
    else
      foundSolution = false
      # Parse `a:b` inside a rule(or similar) as property instead of selector
      if @opts.parseOptions?.parentContext in PROPERTY_CONTAINING
        Stack.init()
        Stack.setValid true
        cssParser[PARSE_CONTEXTS.property] @text
        if Stack.top().children[0]?.type is 'property'
          foundSolution = true
      if not foundSolution
        for parse in ParseOrder
          try
            Stack.init()
            Stack.setValid true
            ast = cssParser[parse] @text
          catch e
            Stack.setValid false
          if Stack.getValid()
            break
    if Stack.getValid()
      root = ast ? Stack.top()
      @nameTree root
      @mark 0, root, 0
    else
      throw "Invalid Data"

  mark: (indentDepth, node, depth) ->
    switch node.nodeType
      when 'stylesheet'
        for child in node.children
          @mark indentDepth, child, depth + 1, null
      when 'charset'
        @cssBlock node, depth
        @cssSocket node.charset, depth + 1
      when 'namespace'
        @cssBlock node, depth
        @cssSocket node.prefix, depth + 1
        @cssSocket node.uri, depth + 1
      when 'import'
        @cssBlock node, depth
        @cssSocket node.uri, depth + 1
        for media in node.media
          @cssSocket media, depth + 1
      when 'property'
        @cssBlock node, depth
        #@cssSocket node.property, depth + 1
        dropdown = @getPropertyChoices node
        if dropdown
          @cssSocket node.value, depth + 1, null, null, dropdown
        else
          @mark indentDepth, node.value, depth + 1, null
      when 'fontface'
        @cssBlock node, depth
        @handleCompoundNode indentDepth, node, depth + 1
      when 'viewport'
        @cssBlock node, depth
        @handleCompoundNode indentDepth, node, depth + 1
      when 'keyframes'
        @cssBlock node, depth
        @cssSocket node.name, depth + 1
        @handleCompoundNode indentDepth, node, depth + 1
      when 'keyframerule'
        @cssBlock node, depth
        for key in node.keys
          @cssSocket key, depth + 1
        @handleCompoundNode indentDepth, node, depth + 1
      when 'page'
        @cssBlock node, depth
        @cssSocket node.id, depth + 1
        @cssSocket node.pseudo, + 1
        @handleCompoundNode indentDepth, node, depth + 1
      when 'pagemargin'
        @cssBlock node, depth
        @cssSocket node.margin, depth + 1
        @handleCompoundNode indentDepth, node, depth + 1
      when 'rule'
        @cssBlock node, depth
        for selector in node.selectors
          @cssSocket selector, depth + 1
          @mark indentDepth, selector, depth + 2
        @handleCompoundNode indentDepth, node, depth + 1
      when 'mediaquery'
        @cssBlock node, depth
        for media in node.media
          @cssSocket media, depth + 1
        @handleCompoundNode indentDepth, node, depth + 1
      when 'selector'
        @cssBlock node, depth
        depth++
        for part in node.parts
          if part.modifiers?.length > 0
            for mod in part.modifiers
              @cssSocket mod, depth + 1
              @mark indentDepth, mod, depth + 2
          if part.elementName
            @cssSocket part.elementName, depth + 1
      when 'selector-modifier'
        if node.type in ['class', 'id']
          @cssBlock node, depth + 3
          node.loc.startCol++
          @cssSocket node, depth + 4, null, null, null, node.type
        else if node.type is 'pseudo'
          @cssBlock node, depth + 3
          node.loc.startCol++
          if node.text[1] is ':'
            node.loc.startCol++
            @cssSocket node, depth + 4, null, null, UNITS['pseudoElements'], node.type
          else
            @cssSocket node, depth + 4, null, null, UNITS['pseudoClasses'], node.type
        else if node.type is 'attribute'
          @cssBlock node, depth + 3
          @cssSocket node.attrib, depth + 4, null, null, null, node.type
          @cssSocket node.val, depth + 4, null, null, null, node.type
        else if node.type is 'not'
          @cssBlock node, depth + 3
          arg = node.args[0]
          arg = arg.elementName ? arg.modifiers[0]
          @cssSocket arg, depth + 4, null, null, null, node.type
          @mark indentDepth, arg, depth + 4

      when 'property-value'
        if node.parts.length > 1
          @cssSocket node, depth
          @cssBlock node, depth + 1
        for part in node.parts
          if UNITS[part.type]   #dimension
            @cssSocket part, depth + 2
            @cssBlock part, depth + 3
            bounds = @getBounds part
            @cssSocket part, depth + 4, null, {
              start: bounds.start
              end: {line: bounds.end.line, column: bounds.end.column - part.units.length}
            }
            @cssSocket part, depth + 4, null, {
              start: {line: bounds.end.line, column: bounds.end.column - part.units.length}
              end: bounds.end
            }, UNITS[part.type]
          else if part.args
            @cssSocket part, depth + 2
            @cssBlock part, depth + 3
            @mark indentDepth, part.args, depth + 4
          else if part.type is 'percentage'
            @cssSocket part, depth + 2
            @cssBlock part, depth + 3
            bounds = @getBounds part
            @cssSocket part, depth + 4, null, {
              start: bounds.start
              end: {line: bounds.end.line, column: bounds.end.column - 1}
            }
          else if part.type in ['string', 'integer', 'number', 'uri', 'color', 'identifier']
            @cssSocket part, depth + 2
          else
            null

  handleCompoundNode: (indentDepth, node, depth) ->
    indentBounds = @getIndentBounds node
    prefix = @getIndentPrefix indentBounds, indentDepth
    indentDepth += prefix.length
    @addIndent
      bounds: indentBounds
      depth: depth
      prefix: prefix
      classes: @getClasses node
    for child in node.children
      @mark indentDepth, child, depth + 1

  isComment: (text) ->
    text.match(/^\s*\/\*.*\*\/*$/)

CSSParser.empty = ''

CSSParser.parens = (leading, trailing, node, context) ->
  if context?.type is 'indent' and context?.classes[0] in ['page', 'pagemargin', 'fontface', 'viewport', 'rule', 'keyframerule'] and node.classes[0] in ['selector', 'property']
    trailing ';'
  return

CSSParser.drop = (block, context, pred, next) ->
  blockType = block.classes[0]
  contextType = context.classes[0]
  predType = pred?.classes[0]
  nextType = next?.classes[0]

  if contextType is 'unknown'
    return helper.FORBID

  if blockType is 'charset'
    if context.type is 'document' and pred.type is 'document' and nextType isnt 'charset'
      return helper.ENCOURAGE
    return helper.FORBID

  if blockType is 'import'
    if context.type is 'document' and (pred.type is 'document' or predType in ['charset', 'import']) and nextType isnt 'charset'
      return helper.ENCOURAGE
    return helper.FORBID

  if blockType is 'namespace'
    if context.type is 'document' and (pred.type is 'document' or predType in ['charset', 'import', 'namespace']) and nextType not in ['charset', 'import']
      return helper.ENCOURAGE
    return helper.FORBID

  if blockType is 'property'
    if contextType in ['page', 'pagemargin', 'fontface', 'viewport', 'rule', 'keyframerule']
      if 'no-semicolon' in pred.classes
        return helper.FORBID
      if 'no-semicolon' not in block.classes
        return helper.ENCOURAGE
      if not next
        return helper.ENCOURAGE
    return helper.FORBID

  if blockType is 'selector-modifier'
    if contextType in ['selector', 'selector-part', 'selector-elementname', 'selector-modifier']
      return helper.ENCOURAGE
    return helper.FORBID

  if blockType is 'selector'
    if contextType is 'selector'
      return helper.ENCOURAGE
    return helper.FORBID

  if context.type is 'document'
    if blockType in ['rule', 'mediaquery', 'page', 'fontface', 'keyframes', 'viewport'] and nextType not in ['charset', 'import', 'namespace']
      return helper.ENCOURAGE
    return helper.FORBID

  if contextType is 'mediaquery'
    if blockType in ['rule', 'page', 'viewport', 'fontface']
      return helper.ENCOURAGE
    return helper.FORBID

  if contextType is 'page'
    if blockType is 'pagemargin'
      return helper.ENCOURAGE
    return helper.FORBID

  if contextType is 'keyframes'
    if blockType is 'keyframerule'
      return helper.ENCOURAGE
    return helper.FORBID

  return helper.DISCOURAGE

CSSParser.handleButton = (text, command, classes) ->
  isComment = (str) ->
    text.match(/^\s*\/\*.\*\/*$/)

  if command is 'add-button'
    text = text.split('}')[0] + '  a: b;\n' + '}';

  return text

module.exports = parser.wrapParser CSSParser