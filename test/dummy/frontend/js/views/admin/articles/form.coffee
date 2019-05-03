class App.Views.Admin.Articles.Form extends App.Views.Base
  constructor: (opts = {}) ->
    super opts

  render: (article) ->
    article.setDefaultValuesForAdminReview()
    form = new App.UI.Form id: 'edit_article_form', for: article
    form.render()