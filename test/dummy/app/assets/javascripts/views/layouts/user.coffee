class App.Views.Layouts.User extends App.Views.Base
  constructor: (opts = {}) -> super opts

  getCurrentUserId: -> parseInt $('#sign_out_user').data 'user-id'
