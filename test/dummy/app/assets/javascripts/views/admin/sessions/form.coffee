class App.Views.Admin.Sessions.Form extends App.Views.Base
  constructor: (opts = {}) ->
    super opts

  render: ->
    form = new App.UI.Form id: 'sign_in_admin', delegator: this, callbackSuccess: '_signedIn'
    form.render()

  _signedIn: ->
    window.location.href = "/admin"
