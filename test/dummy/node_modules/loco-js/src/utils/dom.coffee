class DomUtils
  @hasClass: (el, className) ->
    if el.classList
      el.classList.contains(className)
    else
      new RegExp('(^| )' + className + '( |$)', 'gi').test(el.className)

  @addClass: (el, className) ->
    if el.classList
      el.classList.add(className)
    else
      el.className += ' ' + className

  @removeClass: (el, className) ->
    if el.classList
      el.classList.remove(className)
    else
      el.className = el.className.replace(new RegExp('(^|\\b)' + className.split(' ').join('|') + '(\\b|$)', 'gi'), ' ')

export default DomUtils