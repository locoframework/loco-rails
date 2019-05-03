class App.Controllers.Main.Pages extends App.Controllers.Base
  index: ->
    (new App.Views.Main.Pages.ArticleList).render()