class App.Controllers.Admin.Users extends App.Controllers.Base
  index: ->
    @view = new App.Views.Admin.Users.List users: []
    @view.render()
    this.connectWith [App.Models.User]
    App.Models.User.get("all").then (resp) => @view.renderUsers resp.resources

  show: ->
    view = new App.Views.Admin.Users.Show
    App.Models.User.find(@params.id).then (user) => view.render user

  edit: ->
    view = new App.Views.Admin.Users.Form user: new App.Models.User id: @params.id
    view.render()

  receivedSignal: (signal, data) ->
    switch signal
      when "User created"
        App.Models.User.find(data.id).then (user) => @view.renderUsers [user], 'prepend'