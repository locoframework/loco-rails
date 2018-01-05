class ArrayUtils
  @map: (arr, func) ->
    newArr = []
    for o in arr
      newArr.push func(o)
    newArr

  @uniq: (arr) ->
    newArr = []
    for o in arr
      newArr.push(o) if newArr.indexOf(o) is -1
    newArr

export default ArrayUtils