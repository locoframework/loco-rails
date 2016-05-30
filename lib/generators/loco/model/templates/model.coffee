class App.Models.#{name} extends App.Models.Base
  @identity = "#{name}"
  @resources =
    url: "/#{plural_name}", paginate: {per: 100, param: "page"}  # param is optional
    #admin:
    #  url: "/admin/#{plural_name}", paginate: {per: 100}

  @attributes = #{attributes}

  @receivedSignal: (signal, data) ->

  @validate = []

  constructor: (data) ->
    super data

  receivedSignal: (signal, data) ->