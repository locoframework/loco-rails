class App.Views.Admin.Users.Show extends App.Views.Base
  constructor: (opts = {}) ->
    super opts
    @user = null

  render: (user) ->
    @user = user
    document.getElementById('user_email').textContent = @user.email
    document.getElementById('user_username').textContent = @user.username
    document.getElementById('user_confirmed').textContent = if @user.confirmed then "Yes" else "No"
    this._updateEditLink()

  _updateEditLink: ->
    editLink = document.getElementById('edit_link')
    href = editLink.getAttribute('href')
    editLink.setAttribute('href', href.replace("/0/", "/#{@user.id}/"))