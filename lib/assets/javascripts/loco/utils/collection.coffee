class App.Utils.Collection
  @find: (collection, func) -> return o if func(o) is true for o in collection