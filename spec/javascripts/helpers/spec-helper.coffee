beforeEach ->
  App.Env.loco.getWire().disableNotifications()

  this.paramsStrToHash = (str) ->
    params = {}
    paramsArray = str.split('&')
    paramsArray = _.map paramsArray, (s) -> s.split '='
    for arr in paramsArray
      key = decodeURIComponent arr[0]
      val = decodeURIComponent arr[1]
      if val?
        val = val.replace /\+/g, " "
      params[key] = val
    params