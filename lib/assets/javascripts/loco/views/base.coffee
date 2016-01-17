class App.Views.Base extends App.Mix App.Mixins.Connectivity
  constructor: (opts = {}) ->
    @views = {}
    @intervals = {}
    @receivers = {}
    @controller = null
    @delegator = null
    this.setController(opts.controller) if opts.controller?
    this.setDelegator(opts.delegator) if opts.delegator?

  setController: (cntr) -> @controller = cntr
  getController: -> @controller

  setView: (key, view) -> @views[key] = view
  getView: (key) -> @views[key]
  getViews: -> @views

  setDelegator: (delegator) -> @delegator = delegator