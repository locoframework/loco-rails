class App.Views.Admin.Comments.Form extends App.Views.Base
  constructor: (opts = {}) ->
    super opts

  render: (opts = {}) ->
    form = new App.UI.Form
      for: new App.Models.Article.Comment id: opts.commentId, resource: 'admin'
      id: "edit_comment_#{opts.commentId}"
      initObj: true
    form.render()
    # only for testing purpose
    App.Env.test = commentFormObj: form.getObj()