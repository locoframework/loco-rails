class App.Controllers.Admin.Users extends App.Controllers.Base
  index: ->
    @view = new App.Views.Admin.Users.List users: []
    this.connectWith [App.Models.User]
    App.Models.User.get "all", {}, (users) => @view.renderUsers users

  show: ->
    view = new App.Views.Admin.Users.Show
    App.Models.User.find @params.id, (user) => view.render user

  edit: ->
    view = new App.Views.Admin.Users.Form user: new App.Models.User id: @params.id
    view.render()

  receivedSignal: (signal, data) ->
    switch signal
      when "User created"
        App.Models.User.find data.id, (user) => @view.renderUsers [user], 'prepend'