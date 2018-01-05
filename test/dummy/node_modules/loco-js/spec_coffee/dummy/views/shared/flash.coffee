class App.Views.Shared.Flash extends App.Views.Base
  constructor: (opts = {}) ->
    super opts
    @notice = opts.notice ? null
    @alert = opts.alert ? null
    @warning = opts.warning ? null

  setNotice: (text) -> @notice = text
  setAlert: (text) -> @alert = text
  setWarning: (text) -> @warning = text

  render: ->
    node = $('.flash')
    node.removeClass('notice').removeClass('alert').removeClass('warning')
    if @notice?
      node.addClass 'notice'
      node.find('p').text @notice
    else if @alert?
      node.addClass 'alert'
      node.find('p').text @alert
    else if @warning?
      node.addClass 'warning'
      node.find('p').text @warning
    node.slideDown 'normal'
    this.hide()

  hide: (time = 4000) ->
    setTimeout ->
      $('.flash').slideUp 'normal'
    , time