angular.module 'mnoEnterpriseAngular'
.config ($stateProvider, $urlRouterProvider, URI) ->

  $stateProvider
  .state 'home',
    abstract: true
    url: '?dhbRefId'
    templateUrl: 'app/views/layout.html'
    controller: 'LayoutController'
    controllerAs: 'layout'
  .state 'home.impac',
    url: '/impac'
    templateUrl: 'app/views/impac/impac.html'
    controller: 'ImpacController'
  .state 'home.settings',
    url: '/settings'
    templateUrl: 'app/views/settings/settings.html'
    controller: 'DashboardSettingsCtrl'
    controllerAs: 'vm'
  .state 'home.company',
    url: '/company'
    templateUrl: 'app/views/company/company.html'
    controller: 'DashboardCompanyCtrl'
    controllerAs: 'vm'
  .state 'home.apps',
    url: '/apps'
    templateUrl: 'app/views/apps/dashboard-apps-list.html'
    controller: 'DashboardAppsListCtrl'
  .state 'home.apps.app',
    url: '^/apps/:appId'
    views: '@home':
      templateUrl: 'app/views/marketplace/marketplace-app.html'
      controller: 'DashboardMarketplaceAppCtrl'
      controllerAs: 'vm'
  .state 'home.support',
    url: '/support'
    templateUrl: 'app/views/support/support.html'
    controller: 'DashboardSupportCtrl'
    controllerAs: 'vm'
  .state 'home.customers',
    url: '/customers'
    templateUrl: 'app/views/customers/customers.html'
    controller: 'DashboardCustomersCtrl'
    controllerAs: 'vm'
  .state 'logout',
    url: '/logout'
    controller: ($window, $http, $translate) ->
      'ngInject'

      # Logout and redirect the user
      $http.delete(URI.logout).then( ->
        $window.location.href = "/#{$translate.use()}#{URI.login}"
      )

  $urlRouterProvider.otherwise '/impac'
