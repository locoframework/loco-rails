class App.Helpers.Text
  constructor: (opts = {}) ->

  simpleFormat: (str) ->
    str = str.replace /\r\n?/, "\n"
    str = $.trim str
    if str.length > 0
      str = str.replace /\n\n+/g, '</p><p>'
      str = str.replace /\n/g, '<br>'
      str = '<p>' + str + '</p>'
    str