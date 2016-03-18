App.Views.Main =
  Users: {}
  Pages: {}
  Articles: {}
App.Views.User =
  Articles: {}
App.Views.Admin =
  Users: {}
App.Views.Layouts = {}
App.Views.Shared = {}

loco = new App.Loco
  turbolinks: true
  notifications: true
  pollingTime: 3000
  logNotifications: true
  locale: 'en'
  postInit: ->
    time = if $('body').data('rails-env') is 'test' then 1000 else 3000
    App.Env.loco.getWire().setPollingTime time

loco.init()