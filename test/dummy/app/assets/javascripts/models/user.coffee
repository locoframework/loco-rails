class App.Models.User extends App.Models.Base
  @identity = "User"
  @resources =
    url: "/users"
    admin:
      url: "/admin/users"

  @paginate = {per: 10}

  @attributes =
    email:
      validations:
        presence: true
        format: {with: /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}
    username:
      validations:
        presence: true
        format: {with: /^[a-z][a-z0-9_\-]*$/i}
    password:
      validations:
        presence: {on: "create"}
        confirmation: true
    passwordConfirmation:
      remoteName: "password_confirmation"
    confirmed: {}
    createdAt:
      type: "Date"
      remoteName: "created_at"
    updatedAt:
      type: "Date"
      remoteName: "updated_at"

  @receivedSignal: (signal, data) -> console.log "App.Models.User.receivedSignal: #{signal}"

  constructor: (data) -> super data

  receivedSignal: (signal, data) -> console.log "App.Models.User#receivedSignal: #{signal}"