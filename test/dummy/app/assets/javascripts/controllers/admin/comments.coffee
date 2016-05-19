class App.Controllers.Admin.Comments extends App.Controllers.Base
  edit: ->
    view = new App.Views.Admin.Comments.Form
    view.render commentId: @params.id