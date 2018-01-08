App.Views.Main = {}
App.Views.Main.Users = {}
App.Views.Main.Pages = {}
App.Views.Main.Articles = {}

App.Views.User = {}
App.Views.User.Rooms = {}
App.Views.User.Articles = {}

App.Views.Admin = {}
App.Views.Admin.Sessions = {}
App.Views.Admin.Users = {}
App.Views.Admin.Articles = {}
App.Views.Admin.Comments = {}

App.Views.Layouts = {}
App.Views.Shared = {}

App.Deps.cable = App.cable
App.Deps.NotificationCenter = App.Services.NotificationCenter

loco = new App.Loco
  # set to your Turbolinks version if you have enabled Turbolinks
  turbolinks: 5                       # false by default

  # your browser's app will be checking for new notifications periodically via ajax polling
  notifications:
    enable: true                      # false by default
    #pollingTime: 3000                # 3000 ms by default

    # display upcoming notifications in browser's console e.g. for debugging
    log: true                        # false by default

    #ssl: false                       # your current protocol by default

    # location must the same as where you mount Loco in routes.rb
    #location: 'notification-center'  # 'notification-center' by default

    # max number of notifications that is fetched at once via ajax pooling
    # must be the same as notifications_size defined in initializers/loco.rb
    # next batch of notifications will be fetched immediately after max size is reached
    size: 10                        # 100 by default

    # after this time your current namespace controller / controller instance method
    # disconnectedForTooLong: will be called with the 'time since disconnection' passed as an argument
    #allowedDisconnectionTime: 10     # 10 by default [sec]
  #locale: 'en'                       # 'en' by default

  # if provided - loco will be using absolute path instead of site-root-relative path in all xhr requests
  #protocolWithHost: 'https://example.com'

  # this method is called at the end, after given controller methods has been called
  # at this time Loco's instance is initialized and you can use it to change behaviour of your browser app
  # e.g. polling interval -> App.Env.loco.getWire().setPollingTime <time>
  postInit: ->
    return if $('body').data('rails-env') isnt 'test'
    App.Env.loco.getWire().setPollingTime 1000

loco.init()