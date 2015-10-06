class App.Controllers.Base extends App.Mix App.Mixins.Connectivity
  constructor: ->
    @views = {}
    @receivers = {}
    @subController = null
    @superController = null
    @params = this.__fetchParams()

  getViews: -> @views

  setSubController: (cntrlr) -> @subController = cntrlr

  setSuperController: (cntrlr) -> @superController = cntrlr

  getSubController: -> @subController

  getSuperController: -> @superController

  __fetchParams: ->
    params = {}
    match = /https?:\/\/.+\/\w+\/(\d+)/.exec window.location.href
    id = if match? then match[1] else null
    params["id"] = parseInt(id) if id?
    splitUrl = window.location.href.split '?'
    if splitUrl.length is 1
      return params
    paramsString = _.last splitUrl
    paramsArray = _.map paramsString.split('&'), (s) -> s.split '='
    for arr in paramsArray
      key = decodeURIComponent arr[0]
      val = decodeURIComponent arr[1]
      if val?
        val = val.replace "+", " "
      params[key] = val
    params