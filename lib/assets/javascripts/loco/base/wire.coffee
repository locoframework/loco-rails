class App.Wire
  constructor: (opts = {}) ->
    @syncTime = null

  connect: ->
    this._check()
    setInterval =>
      this._check()
    , 10000

  _check: ->
    jqxhr = $.ajax({
      method: "GET",
      url: "/notification-center",
      data: {
        synced_at: if @syncTime? then @syncTime.toISOString() else null
      }
    })
    jqxhr.always ->
    jqxhr.fail ->
    jqxhr.done (data) =>
      @syncTime = new Date Date.parse data[1]
      notifications = data[0]
      return if notifications.length is 0
      for arr in notifications
        className = arr[0]
        id = arr[1]
        signal = arr[2]
        payload = arr[3]
        klass = this._getClass className
        identity = klass.getIdentity()
        if id?
          func = (id, signal, payload, klass, identity) =>
            flattenPayload = if payload? and payload.routing_data?
              this._flattenPayload payload
            else
              payload
            klass.find this._getFindParams(klass, id, payload), (obj) ->
              if obj?
                obj.receivedSignal signal, flattenPayload if obj["receivedSignal"]?
                for connObj in App.IdentityMap.findConnected identity, id
                  if connObj.receiverFor(obj)? then connObj[connObj.receiverFor(obj)] signal, flattenPayload
                  else if connObj["receivedSignal"]? then connObj.receivedSignal signal, flattenPayload
          func id, signal, payload, klass, identity
        else
          klass.receivedSignal(signal, payload) if klass["receivedSignal"]?
        return if not App.IdentityMap.imap[identity]?
        return if not App.IdentityMap.imap[identity]["collection"]?
        return if App.IdentityMap.imap[identity]["collection"].length is 0
        payload = this._flattenPayload payload if payload? and payload.routing_data?
        for obj in App.IdentityMap.imap[identity]["collection"]
          if obj.receiverFor(identity)?
            obj[obj.receiverFor(identity)] "#{identity} #{signal}", payload
          else if obj["receivedSignal"]?
            obj.receivedSignal "#{identity} #{signal}", payload

  _getClass: (className) ->
    for klass, _ of App.IdentityMap.imap
      parts = klass.split "."
      if parts.length is 1
        return App.Models[parts[0]] if App.Models[parts[0]].getRemoteName() is className
      else if parts.length is 2
        return App.Models[parts[0]][parts[1]] if App.Models[parts[0]][parts[1]].getRemoteName() is className

  _getFindParams: (klass, id, payload) ->
    if payload? and payload["routing_data"]?
      findParams = JSON.parse JSON.stringify payload["routing_data"]
      findParams.id = id
      findParams
    else
      findParams = id
    for attrib in klass.getResourcesUrlParams()
      remoteName = klass.getAttribRemoteName attrib
      continue if not findParams[remoteName]?
      val = findParams[remoteName]
      delete findParams[remoteName]
      findParams[attrib] = val
    findParams

  _flattenPayload: (payload) ->
    result = JSON.parse JSON.stringify payload
    routingData = result.routing_data
    delete result.routing_data
    for key, val of routingData
      result[key] = val
    result