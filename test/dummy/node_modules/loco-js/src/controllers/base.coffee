import Mix from '../base/mix.coffee'
import Connectivity from '../base/mixins/connectivity.coffee'
import {Config} from '../deps';
import ArrayUtils from '../utils/array.coffee'

class Base extends Mix Connectivity
  constructor: ->
    super()
    @views = {}
    @receivers = {}
    @subController = null
    @superController = null
    @params = this.__fetchParams()

  setView: (key, view) -> @views[key] = view
  getView: (key) -> @views[key]
  getViews: -> @views

  setSubController: (cntrlr) -> @subController = cntrlr
  getSubController: -> @subController

  setSuperController: (cntrlr) -> @superController = cntrlr
  getSuperController: -> @superController

  setResource: (name) -> this.setScope name
  setScope: (name) -> Config.scope = name

  __fetchParams: ->
    params = {}
    match = /https?:\/\/.+\/\w+\/(\d+)/.exec window.location.href
    id = if match? then match[1] else null
    params["id"] = parseInt(id) if id?
    splitUrl = window.location.href.split '?'
    if splitUrl.length is 1
      return params
    paramsString = splitUrl[splitUrl.length - 1]
    paramsArray = ArrayUtils.map paramsString.split('&'), (s) -> s.split '='
    for arr in paramsArray
      key = decodeURIComponent arr[0]
      val = decodeURIComponent arr[1]
      if val?
        val = val.replace /\+/g, " "
      params[key] = val
    params

export default Base