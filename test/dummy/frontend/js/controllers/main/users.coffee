class App.Controllers.Main.Users extends App.Controllers.Base
  new: ->
    view = new App.Views.Main.Users.UserRegistrationForm
    view.render()
