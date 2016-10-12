class App.Controllers.User.Rooms extends App.Controllers.Base
  initialize: ->

  show: ->
    this.setView 'show', new App.Views.User.Rooms.Show id: @params.id
    this.getView('show').render()