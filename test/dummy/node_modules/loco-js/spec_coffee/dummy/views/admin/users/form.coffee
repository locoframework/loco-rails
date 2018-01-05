class App.Views.Admin.Users.Form extends App.Views.Base
  constructor: (opts = {}) ->
    super opts
    @user = opts.user

  render: ->
    form = new App.UI.Form for: @user, initObj: true, id: "admin_user_form"
    form.render()