class App.Loco
  constructor: (opts={}) ->
    @turbolinks = if opts.turbolinks? and opts.turbolinks then true else false
    @wire = if opts.notifications? and opts.notifications then true else false

  init: ->
    if @wire
      wire = new App.Wire
      wire.connect()
    if @turbolinks
      jQuery(document).on "page:change", => this.flow()
    else
      jQuery => this.flow()

  flow: ->
    App.IdentityMap.clear()

    namespace_name = $('body').data 'namespace'
    controller_name = $('body').data 'controller'
    action_name = $('body').data 'action'

    App.Env.action = action_name

    if App.Controllers[namespace_name]?
      App.Env.namespaceController = new App.Controllers[namespace_name]
      if App.Controllers[namespace_name][controller_name]?
        App.Env.controller = new App.Controllers[namespace_name][controller_name]
      App.Env.namespaceController.initialize() if App.Env.namespaceController.initialize?
      if App.Env.controller?
        App.Env.namespaceController.setSubController App.Env.controller
        App.Env.controller.setSuperController App.Env.namespaceController
        App.Env.controller.initialize() if App.Env.controller.initialize?
        App.Env.controller[action_name]() if App.Env.controller[action_name]?
    else if App.Controllers[controller_name]
      App.Env.controller = new App.Controllers[controller_name]
      App.Env.controller.initialize() if App.Env.controller.initialize?
      App.Env.controller[action_name]() if App.Env.controller[action_name]?