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

loco = new App.Loco turbolinks: true, notifications: true, logNotifications: true, locale: 'en'
loco.init()