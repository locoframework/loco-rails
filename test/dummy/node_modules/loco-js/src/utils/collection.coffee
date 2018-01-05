class CollectionUtils
  @find: (collection, func) ->
    for o in collection
      return o if func(o) is true

export default CollectionUtils