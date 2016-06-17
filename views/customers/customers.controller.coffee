angular.module 'mnoEnterpriseAngular'
  .controller('DashboardCustomersCtrl', (MnoeCurrentUser, MnoeOrganizations, $http, toastr) ->
    vm = this

    vm.loading = true
    vm.customers = []
    vm.email = ""
    vm.search = ""

    MnoeCurrentUser.get().then(
      (response) ->
        vm.customers = response.organizations
        vm.loading = false
    )

    vm.getFilteredCustomers = () ->
      if !vm.search
        return vm.customers
      else
        pattern = ///^#{vm.search.toLowerCase()}///
        _.filter(vm.customers, (customer) ->
          customer.name.split(' ').some (partName) ->
            partName.toLowerCase().match(pattern)
        )

    vm.accessDashboard = (id) ->
      window.location.href = "#/"

    vm.sendMail = ->
      return if _.isEmpty(vm.email)
      
      vm.loading = true
      recipient =
        email: vm.email

      $http.post('jpi/v1/current_user/invite_user', {recipient: recipient}).then(
        (success)->
          vm.loading = false
          toastr.success("#{success.data.message}")
          if success.data.reload
            MnoeCurrentUser.get().then(
              (response) ->
                currentUids = _.map(vm.customers, (c) -> c.uid)
                for org in response.data.current_user.organizations
                  vm.customers.push org unless _.contains(currentUids, org.uid)
            )

        (error) ->
          vm.loading = false
          message = error.data.message || "The invitation could not be sent. Please contact a system administrator."
          toastr.error("#{message}")

      )

    return
)