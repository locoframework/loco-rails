class IdentityMap
  # Ex.
  # @imap = {
  #   Post: {
  #     1: [
  #       #<Post id:1>
  #     ],
  #     10: [
  #       #<Post id:10>
  #     ],
  #     collection: [
  #       #<Posts>
  #     ]
  #   }
  # }
  @imap = {}

  @clear: -> @imap = {}

  @add: (obj) ->
    identity = obj.getIdentity()
    if not @imap[identity]?
      @imap[identity] = {}
    if not @imap[identity][obj.id]?
      @imap[identity][obj.id] = []
    @imap[identity][obj.id][0] = obj

  @connect: (obj, opts = {}) ->
    model = opts.with
    @add model
    @imap[model.getIdentity()][model.id].push obj

  @addCollection: (identity, opts = {}) ->
    if not @imap[identity]?
      @imap[identity] = {}
    if not @imap[identity]["collection"]?
      @imap[identity]["collection"] = []
    return if @imap[identity]["collection"].indexOf(opts.to) isnt -1
    @imap[identity]["collection"].push opts.to

  @all: (identity) ->
    return null if not @imap[identity]?
    arr = []
    for id, objs of @imap[identity]
      continue if id is "collection"
      arr.push objs[0]
    return arr

  @find: (klass, id) ->
    if @imap[klass] and @imap[klass][id] then @imap[klass][id][0] else null

  @findConnected: (klass, id) ->
    if @imap[klass] and @imap[klass][id] and @imap[klass][id].length > 1
      arr = @imap[klass][id]
      arr[1..(arr.length - 1)]
    else
      []

export default IdentityMap