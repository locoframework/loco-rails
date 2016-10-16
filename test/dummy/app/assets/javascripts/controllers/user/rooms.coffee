class App.Controllers.User.Rooms extends App.Controllers.Base
  initialize: ->

  index: ->
    view = new App.Views.User.Rooms.List
    view.render()

  show: ->
    view = new App.Views.User.Rooms.Show id: @params.id
    this.setView 'show', view
    view.render()
    App.Models.Room.Member.all(roomId: @params.id).then (resp) ->
      view.renderMembers resp.resources