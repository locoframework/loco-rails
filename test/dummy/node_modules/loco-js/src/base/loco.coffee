import {Config, Deps, IdentityMap, Models} from '../deps'
import Wire from './wire.coffee'
import Line from './line.coffee'
import Env from '../env'
import Controllers from '../controllers'

class Loco
  constructor: (opts={}) ->
    @wire = null
    @line = null
    @turbolinks = opts.turbolinks ? false
    @startWire = if opts.notifications?.enable then true else false
    @postInit = opts.postInit
    this.setLocale opts.locale ? 'en'
    this.setProtocolWithHost opts.protocolWithHost
    notificationsParams = opts.notifications ? {}
    notificationsParams.protocolWithHost = this.getProtocolWithHost()
    @notificationsParams = notificationsParams

  getWire: -> @wire

  getLine: -> @line

  getLocale: -> Config.locale
  setLocale: (locale) -> Config.locale = locale

  getProtocolWithHost: -> Config.protocolWithHost
  setProtocolWithHost: (val) -> Config.protocolWithHost = val

  init: ->
    Env.loco = this
    this.initWire()
    this.initLine()
    if @turbolinks
      event = if Number(@turbolinks) >= 5 then "turbolinks:load" else "page:change"
      document.addEventListener event, =>
        this.flow()
        @postInit() if @postInit?
    else
      this.ready =>
        this.flow()
        @postInit() if @postInit?

  ready: (fn) ->
    cond = if document.attachEvent then document.readyState is "complete" else document.readyState isnt "loading"
    if cond
      fn()
    else
      document.addEventListener 'DOMContentLoaded', fn

  initWire: ->
    return if not @startWire
    @wire = new Wire @notificationsParams
    @wire.fetchSyncTime after: 'connect'

  initLine: ->
    return unless Deps.cable?
    @line = new Line
    @line.connect()

  flow: ->
    IdentityMap.clear()

    namespace_name = document.getElementsByTagName('body')[0].getAttribute 'data-namespace'
    controller_name = document.getElementsByTagName('body')[0].getAttribute 'data-controller'
    action_name = document.getElementsByTagName('body')[0].getAttribute 'data-action'

    Env.action = action_name

    if Controllers[namespace_name]?
      Env.namespaceController = new Controllers[namespace_name]
      if Controllers[namespace_name][controller_name]?
        Env.controller = new Controllers[namespace_name][controller_name]
      Env.namespaceController.constructor.initialize() if Env.namespaceController.constructor.initialize?
      Env.namespaceController.initialize() if Env.namespaceController.initialize?
      if Env.controller?
        Env.namespaceController.setSubController Env.controller
        Env.controller.setSuperController Env.namespaceController
        Env.controller.constructor.initialize() if Env.controller.constructor.initialize?
        Env.controller.initialize() if Env.controller.initialize?
        Env.controller.constructor[action_name]() if Env.controller.constructor[action_name]?
        Env.controller[action_name]() if Env.controller[action_name]?
    else if Controllers[controller_name]
      Env.controller = new Controllers[controller_name]
      Env.controller.constructor.initialize() if Env.controller.constructor.initialize?
      Env.controller.initialize() if Env.controller.initialize?
      Env.controller.constructor[action_name]() if Env.controller.constructor[action_name]?
      Env.controller[action_name]() if Env.controller[action_name]?

    if @wire?
      @wire.resetSyncTime()
      @wire.fetchSyncTime()

  emit: (data) -> @line.send data

  getModels: ->
    models = []
    regExp = /^[A-Z]/
    for func, _ of Models
      continue if !regExp.exec(func) or func is "Base"
      models.push func
      for innerFunc, _ of Models[func]
        models.push "#{func}.#{innerFunc}" if regExp.exec innerFunc
    models

  getModelForRemoteName: (remoteName) ->
    for model in this.getModels()
      parts = model.split "."
      if parts.length is 1
        return Models[parts[0]] if Models[parts[0]].getRemoteName() is remoteName
      else if parts.length is 2
        return Models[parts[0]][parts[1]] if Models[parts[0]][parts[1]].getRemoteName() is remoteName

export default Loco