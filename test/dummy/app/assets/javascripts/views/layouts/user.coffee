class App.Views.Layouts.User extends App.Views.Base
  constructor: (opts = {}) -> super opts

  getCurrentUserId: ->
    parseInt(document.getElementById('sign_out_user').getAttribute(''))
