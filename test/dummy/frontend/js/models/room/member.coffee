import { Models } from "loco-js"

class Member extends Models.Base
  @identity = "Room.Member"
  @resources =
    url: '/user/rooms/:roomId/members', paginate: {per: 100}

  @attributes = {}

  @receivedSignal: (signal, data) ->

  @validate = []

  constructor: (data) ->
    super data

  receivedSignal: (signal, data) ->

export default Member
