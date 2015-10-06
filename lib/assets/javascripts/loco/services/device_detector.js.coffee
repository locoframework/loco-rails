class App.Services.DeviceDetector
  constructor: (opts = {}) ->
    @delegator = null
    @orientationChangeDelegatedMethod = null
    @resizeDelegatedMethod = null
    this._init()

  setDelegator: (delegator) -> @delegator = delegator

  viewportWidth: -> Math.max(document.documentElement.clientWidth, window.innerWidth || 0)

  viewportHeight: -> Math.max(document.documentElement.clientHeight, window.innerHeight || 0)

  # like iPhone 4, 5
  isShort: -> if $(window).height() < 628 then true else false  # 669

  isLarge: -> $("row_root").hasClass 'large'

  getOrientation: -> @orientation

  delegateOrientationChangeTo: (method) -> @orientationChangeDelegatedMethod = method

  delegateResizeTo: (method) -> @resizeDelegatedMethod = method

  _init: ->
    window.addEventListener 'orientationchange', this._onOrientationChange
    $(window).on 'resize', Foundation.utils.debounce (event) =>
      this._onResize event
    , 300
    this._onOrientationChange()

  _onOrientationChange: =>
    switch window.orientation
      when -90, 90
        @orientation = "landscape"
      else
        @orientation = "portrait"
    if @delegator?
      @delegator[@orientationChangeDelegatedMethod](@orientation)

  _onResize: (event) =>
    if @delegator? and @resizeDelegatedMethod?
      @delegator[@resizeDelegatedMethod](event)