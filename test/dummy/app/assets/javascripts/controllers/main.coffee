class App.Controllers.Main extends App.Mix App.Controllers.Base, App.Mixins.Disconnection
  initialize: -> this.setScope 'main'