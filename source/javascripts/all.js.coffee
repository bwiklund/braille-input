# hello

app = angular.module('brailleTap',[])

app.directive 'multiTouch', ->
  link: (scope,el,attrs) ->
    scope.foo = 'asdf'
    el.on 'touchstart touchmove', (e) -> 
      scope.$apply ->
        scope.touches = e.touches
      e.preventDefault()
      false


# a bitwise mapping of inputs to letters.
#
# order is:
#
# 1 2
# 3 4
# 5 6
app.value 'braileMapping',
  0b000001: 'a'
  0b000011: 'b'
  0b000101: 'c'
  0b001011: 'd'
  0b001001: 'e'
  0b000111: 'f'
  0b001111: 'g'
  0b001101: 'h'
  0b000110: 'i'
  0b001110: 'j'
  0b010001: 'k'
  0b010101: 'l'
  0b010011: 'm'
  0b011011: 'n'
  0b011001: 'o'
  0b010111: 'p'
  0b011111: 'q'
  0b011101: 'r'
  0b010110: 's'
  0b011110: 't'
  0b110001: 'u'
  0b110101: 'v'
  0b101110: 'w'
  0b110011: 'x'
  0b111011: 'y'
  0b111001: 'z'


app.directive 'brailleInput', ($parse,braileMapping) ->
  link: (scope,el,attrs) ->

    regions = null

    resetRegions = ->
      regions = [false,false,false,false,false,false]

    fn = $parse attrs.onLetter

    resetRegions()

    el.on 'touchstart touchmove', (e) ->
      scope.$apply -> # TODO: debounce probably
        for touch in e.touches
          _el = document.elementFromPoint touch.pageX, touch.pageY
          if _el.parentNode == el[0]
            # not the angular waaaaaaaaaay
            $_el = angular.element(_el)
            n = parseInt $_el.attr 'braille-region'
            regions[n] = true
            $_el.addClass 'active'

      e.preventDefault() # otherwise only one touchmove will fire... huh.
      return

    el.on 'touchend', (e) ->
      if e.touches.length == 0 # all fingers up
        el.find('*').removeClass 'active'
        bits = 0
        bits |= r << i for r,i in regions
        letter = braileMapping[ bits ] || ''
        scope.$apply -> fn scope, $letter: letter
        resetRegions()


app.controller 'MainCtrl', ($scope) ->
  $scope.message = ''
  $scope.addLetter = (letter) ->
    $scope.message += letter


# app.directive 'brailleRegion', ->
#   link: (scope,el,attrs) ->
#     update = ->
#       el.toggleClass 'active', true

#     el.on 'touchstart touchmove', (e) ->
#       scope.$apply -> # TODO: debounce probably
#         el.toggleClass 'active', true