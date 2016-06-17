angular.module 'mnoEnterpriseAngular'
  .controller('TermsModalCtrl', ($scope, $uibModalInstance) ->
    $scope.ok = () ->
      $uibModalInstance.close()
    $scope.cancel = () ->
      $uibModalInstance.dismiss('cancel')
  )