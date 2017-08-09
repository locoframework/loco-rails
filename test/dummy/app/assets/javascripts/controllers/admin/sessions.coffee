class App.Controllers.Admin.Sessions extends App.Controllers.Base
  new: ->
    view = new App.Views.Admin.Sessions.Form
    view.render()
