beforeEach ->
  this.paramsStrToHash = (str) ->
    params = {}
    paramsArray = str.split('&')
    paramsArray = App.Utils.Array.map paramsArray, (s) -> s.split '='
    for arr in paramsArray
      key = decodeURIComponent arr[0]
      val = decodeURIComponent arr[1]
      if val?
        val = val.replace /\+/g, " "
      params[key] = val
    params

afterEach ->
  App.Env.loco.setProtocolWithHost null