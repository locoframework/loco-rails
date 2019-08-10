import { Controllers } from "loco-js";

import Member from "models/room/member.coffee";

import List from "views/user/rooms/list.coffee";
import Show from "views/user/rooms/show.coffee";

class Rooms extends Controllers.Base
  initialize: ->

  index: ->
    view = new List
    view.render()

  show: ->
    view = new Show id: @params.id
    this.setView 'show', view
    view.render()
    Member.all(roomId: @params.id).then (resp) ->
      view.renderMembers resp.resources

export default Rooms;