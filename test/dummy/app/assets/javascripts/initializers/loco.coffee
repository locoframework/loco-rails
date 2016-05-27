App.Views.Main = {}
App.Views.Main.Users = {}
App.Views.Main.Pages = {}
App.Views.Main.Articles = {}

App.Views.User = {}
App.Views.User.Articles = {}

App.Views.Admin = {}
App.Views.Admin.Users = {}
App.Views.Admin.Articles = {}
App.Views.Admin.Comments = {}

App.Views.Layouts = {}
App.Views.Shared = {}

loco = new App.Loco
  turbolinks: true                   # false by default
  notifications:
    enable: true                     # false by default
    pollingTime: 3000                # 3000 ms by default
    log: true                        # false by default
    ssl: false                       # your current protocol by default
    location: 'notification-center'  # 'notification-center' by default
    size: 10                         # 100 by default
    allowedDisconnectionTime: 10     # 10 by default [sec]
  locale: 'en'                       # 'en' by default
  postInit: ->
    time = if $('body').data('rails-env') is 'test' then 1000 else 3000
    App.Env.loco.getWire().setPollingTime time

loco.init()