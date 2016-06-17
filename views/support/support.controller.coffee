angular.module 'mnoEnterpriseAngular'
  .controller('DashboardSupportCtrl', () ->
    vm = this

    vm.loading = false

    vm.openChat = () ->
      if Intercom?
        Intercom('showNewMessage')

    return
)
