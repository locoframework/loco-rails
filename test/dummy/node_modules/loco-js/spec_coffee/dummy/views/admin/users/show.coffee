class App.Views.Admin.Users.Show extends App.Views.Base
  constructor: (opts = {}) ->
    super opts
    @user = null

  render: (user) ->
    @user = user
    $("#user_email").text @user.email
    $("#user_username").text @user.username
    $("#user_confirmed").text if @user.confirmed then "Yes" else "No"
    this._updateEditLink()

  _updateEditLink: ->
    href = $("#edit_link").attr "href"
    $("#edit_link").attr "href", href.replace "/0/", "/#{@user.id}/"