class App.Views.Admin.Users.List extends App.Views.Base
  constructor: (opts = {}) ->
    super opts
    @users = opts.users

  render: ->
    document.querySelector("table tbody").innerHTML = ''

  renderUsers: (users, order = 'append') ->
    for user in users
      if order is 'append'
        renderedUser = JST["templates/admin/users/user"] {user: user}
        document.querySelector("table").insertAdjacentHTML('beforeend', renderedUser)
      else
        renderedUser = JST["templates/admin/users/user"] {user: user}
        document.querySelector("table").insertAdjacentHTML('afterbegin', renderedUser)
    for el in document.querySelectorAll('table a.ping')
      el.addEventListener 'click', (e) ->
        e.preventDefault()
        userId = e.target.parentNode.parentNode.getAttribute('data-id')
        App.Env.loco.emit(signal: 'ping', user_id: userId)
