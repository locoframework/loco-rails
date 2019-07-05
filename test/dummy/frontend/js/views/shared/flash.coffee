import { Views } from "loco-js"

class Flash extends Views.Base
  constructor: (opts = {}) ->
    super opts
    @notice = opts.notice ? null
    @alert = opts.alert ? null
    @warning = opts.warning ? null
    @hide = opts.hide ? true

  setNotice: (text) -> @notice = text
  setAlert: (text) -> @alert = text
  setWarning: (text) -> @warning = text

  render: ->
    node = document.querySelector('.flash')
    node.classList.remove('notice')
    node.classList.remove('alert')
    node.classList.remove('warning')
    if @notice?
      node.classList.add('notice')
      document.querySelector('.flash p').textContent = @notice
    else if @alert?
      node.classList.add('alert')
      document.querySelector('.flash p').textContent = @alert
    else if @warning?
      node.classList.add('warning')
      document.querySelector('.flash p').textContent = @warning
    node.classList.remove('none') # slideDown initially
    this.hideAfterTime() if @hide

  hideAfterTime: (time = 4000) ->
    setTimeout ->
      document.querySelector('.flash').classList.add('none') # slideUp initially
    , time

export default Flash