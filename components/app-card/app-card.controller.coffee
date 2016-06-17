angular.module 'mnoEnterpriseAngular'
  .directive('appCard', ->
    return {
      restrict: 'E',
      scope: {
        app: '=',
        showTick: '='
      },
      templateUrl: 'app/components/app-card/app-card.html'
    }
  )