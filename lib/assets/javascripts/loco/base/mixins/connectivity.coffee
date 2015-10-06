class App.Mixins.Connectivity
  connectWith: (data, opts = {}) ->
    return null if not data?
    if data.constructor.name is "Array"
      for identity in _.uniq _.map(data, (obj) -> obj.getIdentity())
        App.IdentityMap.addCollection identity, to: this
        @receivers[identity] = opts.receiver if opts.receiver?
      return
    @receivers[data.toKey()] = opts.receiver if opts.receiver?
    App.IdentityMap.connect this, with: data

  receiverFor: (data) ->
    if data.constructor.name is "String"
      return if @receivers[data]? then @receivers[data] else null
    return @receivers[data.toKey()] if @receivers[data.toKey()]?
    null