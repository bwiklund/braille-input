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


app.directive 'brailleInput', ->
  link: (scope,el,attrs) ->

    el.on 'touchmove', (e) ->
      scope.$apply -> # TODO: debounce probably
        for touch in e.touches
          _el = document.elementFromPoint touch.pageX, touch.pageY
          console.log _el
          angular.element(_el).toggleClass 'active', true
      return


# app.directive 'brailleRegion', ->
#   link: (scope,el,attrs) ->
#     update = ->
#       el.toggleClass 'active', true

#     el.on 'touchstart touchmove', (e) ->
#       scope.$apply -> # TODO: debounce probably
#         el.toggleClass 'active', true