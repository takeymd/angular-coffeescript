
#============================================
# Dashboard Menu
#============================================
DashboardMenuCtrl = ($scope, MnoeCurrentUser) ->
  'ngInject'

  $scope.selectBox = {
    user: MnoeCurrentUser.user
  }

  $scope.getCurrentUserAdminRole = () ->
    return MnoeCurrentUser.user.admin_role


angular.module 'mnoEnterpriseAngular'
  .directive('dashboardMenu', ->
    return {
      restrict: 'EA',
      controller: DashboardMenuCtrl,
      templateUrl: 'app/components/dashboard-menu/dashboard-menu.html',

      link: (scope, elem, attrs) ->
        # Need to override the original controller as it was containing expending behaviour
    }
  )
