import { UI, Views } from "loco-js"

import User from "models/User"
import Flash from "views/shared/flash.coffee"

class UserRegistrationForm extends Views.Base
  constructor: (opts = {}) ->
    super opts

  render: ->
    form = new UI.Form for: new User, delegator: this, callbackSuccess: '_created'
    form.render()

  receivedSignal: (signal, data) ->
    switch signal
      when 'confirming' then this._confirming()
      when 'confirmed' then this._confirmed()

  _created: (data) ->
    this.connectWith new User(id: data.id)
    document.querySelector('form').style.display = 'none'
    document.getElementById('sign_in_paragraph').classList.remove('none')
    document.getElementById('verification_info').classList.remove('none')
    flash = new Flash notice: data.notice
    flash.render()

  _confirming: ->
    document.getElementById('verification_info').textContent = document.getElementById('verification_progress').textContent

  _confirmed: -> window.location.href = '/user/sessions/new?event=confirmed'

export default UserRegistrationForm