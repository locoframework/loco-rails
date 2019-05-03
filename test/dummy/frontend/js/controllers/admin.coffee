class App.Controllers.Admin extends App.Mix App.Controllers.Base, App.Mixins.Disconnection
  initialize: -> this.setScope 'admin'