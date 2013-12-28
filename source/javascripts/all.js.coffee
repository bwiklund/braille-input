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
