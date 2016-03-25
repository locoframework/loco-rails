class App.Utils.Array
  @map: (arr, func) ->
    newArr = []
    for o in arr
      newArr.push func(o)
    newArr

  @uniq: (arr, func) ->
    newArr = []
    for o in arr
      newArr.push(o) if newArr.indexOf(o) is -1
    newArr