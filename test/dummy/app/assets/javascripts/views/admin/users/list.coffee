class App.Views.Admin.Users.List extends App.Views.Base
  constructor: (opts = {}) ->
    super opts
    @users = opts.users

  render: ->
    $("table tbody").empty()

  renderUsers: (users, order = 'append') ->
    for user in users
      if order is 'append'
        $("table").append JST["templates/admin/users/user"] {user: user}
      else
        $("table").prepend JST["templates/admin/users/user"] {user: user}
    $('table a.ping').click (e) ->
      e.preventDefault()
      userId = $(e.target).parents('tr').data 'id'
      App.Env.loco.emit todo: 'ping', user_id: userId