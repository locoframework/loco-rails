class App.UI.Tabs
  constructor: (node, delegator) ->
    @sel = $(node)
    @delegator = delegator
    this.handle()

  handle: ->
    elementsSize = @sel.find('a').size()
    @sel.find('a').click (e) =>
      e.preventDefault()
      return if $(e.target).hasClass "active"
      index = 0
      for child in $(e.target).parent().children('a')
        break if $(child).text() is $(e.target).text()
        index += 1
      width = parseInt @sel.css 'width'
      left = width / elementsSize * index
      @sel.find('a.active').removeClass 'active'
      $(e.target).addClass 'active'
      @sel.find('div.background').velocity {left: left}, 200
      @delegator[$(e.target).data("action")]()
