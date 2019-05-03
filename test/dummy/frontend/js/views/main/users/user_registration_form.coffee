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
    document.querySelector('form').style.display = 'none'
    document.getElementById('sign_in_paragraph').classList.remove('none')
    document.getElementById('verification_info').classList.remove('none')
    flash = new App.Views.Shared.Flash notice: data.notice
    flash.render()

  _confirming: ->
    document.getElementById('verification_info').textContent = document.getElementById('verification_progress').textContent

  _confirmed: -> window.location.href = '/user/sessions/new?event=confirmed'
