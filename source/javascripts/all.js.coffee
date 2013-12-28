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


app.directive 'brailleInput', ($parse) ->
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
        console.log regions
        scope.$apply -> fn scope, $letter: 'a'
        resetRegions()


app.controller 'MainCtrl', ($scope) ->
  $scope.message = ''
  $scope.addLetter = (letter) ->
    console.log 'fuck'
    $scope.message += letter


# app.directive 'brailleRegion', ->
#   link: (scope,el,attrs) ->
#     update = ->
#       el.toggleClass 'active', true

#     el.on 'touchstart touchmove', (e) ->
#       scope.$apply -> # TODO: debounce probably
#         el.toggleClass 'active', true