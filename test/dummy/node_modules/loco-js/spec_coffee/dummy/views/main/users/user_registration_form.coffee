class App.Views.Main.Users.UserRegistrationForm extends App.Views.Base
  constructor: (opts = {}) ->
    super opts

  render: ->
    form = new App.UI.Form for: new App.Models.User, delegator: this, callbackSuccess: '_created'
    form.render()

  receivedSignal: (signal, data) ->
    switch signal
      when 'confirming' then this._confirming()
      when 'confirmed' then this._confirmed()

  _created: (data) ->
    this.connectWith new App.Models.User(id: data.id)
    $('form').add('#sign_in_paragraph').hide 'slow'
    $('#verification_info').show 'slow'
    flash = new App.Views.Shared.Flash notice: data.notice
    flash.render()

  _confirming: -> $('#verification_info').text $('#verification_progress').text()

  _confirmed: -> window.location.href = '/user/sessions/new?event=confirmed'
