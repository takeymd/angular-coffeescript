angular.module 'mnoEnterpriseAngular'
  .controller('DashboardAppsListCtrl',
    ($scope, $filter, $q, $location, $state, $stateParams, $window, $uibModal, MnoConfirm, MnoeOrganizations, MnoeAppInstances, MnoeMarketplace, $anchorScroll) ->

      $scope.apps = []
      $scope.isLoading = true

      $scope.helper = {}

      $scope.helper.canDeleteApp = () ->
        MnoeOrganizations.can.destroy.appInstance()

      $scope.helper.appActionUrl = (instance) ->
        "/mnoe/launch/#{instance.uid}"

      $scope.helper.isOauthConnectBtnShown = (instance) ->
        instance.app_nid != 'office-365' &&
        instance.stack == 'connector' &&
        !instance.oauth_keys_valid

      $scope.helper.isLaunchHidden = (instance) ->
        instance.status == 'terminating' ||
        instance.status == 'terminated' ||
        $scope.helper.isOauthConnectBtnShown(instance) ||
        $scope.helper.isNewOfficeApp(instance)

      $scope.helper.isNewOfficeApp = (instance) ->
        instance.stack == 'connector' && instance.appNid == 'office-365' && (moment(instance.createdAt) > moment().subtract({minutes:5}))

      $scope.openAppDeletionModal = (app) ->
        modalInstance = $uibModal.open(
          templateUrl: 'app/views/apps/modals/app-deletion-modal.html'
          controller: 'AppDeletionModalCtrl'
          resolve:
            app: ->
              app
        )

      $scope.$watch MnoeOrganizations.getSelectedId, (val) ->
        if val?
          $scope.isLoading = true
          MnoeAppInstances.getAppInstances().then(
            (response) ->
              $scope.isLoading = false
              $scope.apps = MnoeAppInstances.appInstances
          )

      $scope.openTermsModal = (action, successUrl) ->
        scope = $scope.$new(true)
        scope.action  = action

        modalInstance = $uibModal.open(
          scope: scope,
          templateUrl: 'app/views/apps/modals/terms-modal.html',
          controller: 'TermsModalCtrl'
        )

        modalInstance.result.then((selectedItem) ->
          $window.open(successUrl, '_blank')
        )

      $scope.scrollToMarketplace = () ->
        $location.hash('marketplace')
        $anchorScroll()

      # Marketplace variables
      $scope.marketplace = {}
      $scope.marketplace.loading = true
      $scope.marketplace.selectedCategory = ''
      $scope.marketplace.searchAppsTerm = ''
      $scope.marketplace.appFilter = ''

      # Only display search results if search terms are entered
      $scope.showSearch = () ->
        ($scope.marketplace.searchAppsTerm && $scope.marketplace.searchAppsTerm != '')

      $scope.showAllAppsTitle = () ->
        ((!$scope.marketplace.searchAppsTerm || $scope.marketplace.searchAppsTerm == '') &&
          (!$scope.marketplace.selectedCategory || $scope.marketplace.selectedCategory == ''))

      $scope.showMarketplace = () ->
        (!$scope.showSearch())

      $scope.showCategory = (currentCategory) ->
        if !$scope.marketplace.selectedCategory
          return true
        else
          currentCategory == $scope.marketplace.selectedCategory

      $scope.getAppsByCategory = (category) ->
        _.filter($scope.marketplace.apps, (app) ->
          _.contains(app.categories, category)
        )

      $scope.uncheck = (event) ->
        if (event.target.value == lastChecked)
          delete $scope.marketplace.selectedCategory
          lastChecked = null
        else
          lastChecked = event.target.value

      # Click on an app-card
      $scope.appClick = (app) ->
        if !app.is_coming_soon?
          # Is app already in my apps?
          if _.contains(_.map($scope.apps, (app) -> app.app_nid), app.nid)
            # Scroll to top of page
            $location.hash('myapps')
            $anchorScroll()
          else
            # Route go #/marketplace/{{::app.id}}
            $state.go('home.apps.app', {
              appId: app.id
            })

      $scope.searchAppFilter = (app) ->
        searchTerms = [app.name]
        searchTerms.push app.categories...
        searchTerms.push app.tags... if app.tags?
        $filter('filter')(searchTerms, $scope.marketplace.searchAppsTerm).length > 0
      
      MnoeMarketplace.getApps().then(
        (response) ->
          # Remove restangular decoration
          response = response.plain()

          $scope.marketplace.loading = false
          $scope.marketplace.categories = response.categories
          $scope.marketplace.apps = response.apps
    )
  )