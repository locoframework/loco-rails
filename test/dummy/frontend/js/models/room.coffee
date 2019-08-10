import { Models } from "loco-js"

class Room extends Models.Base
  @identity = "Room"
  @resources = {}

  @attributes = {}

  @receivedSignal: (signal, data) ->

  @validate = []

  constructor: (data) ->
    super data

  receivedSignal: (signal, data) ->

export default Room;