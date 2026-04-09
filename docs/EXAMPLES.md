# Examples

## Chat room — real-time member list

Two users open the same chat room. When one joins or leaves, the other sees the change instantly — no page refresh needed.

### Back-end

**Communication Hub** is a Loco concept — a virtual room stored in Redis where you can add/remove members. Think of it as a named group of recipients you can broadcast to. See the [Hub section](../README.md#communication-hubs) in the README.

```ruby
# app/controllers/user/rooms_controller.rb

# @room is a regular ActiveRecord model (e.g., Room.find(params[:id]))

def join
  hub = Loco.get_hub("room_#{@room.id}")

  hub.add_member(current_user)

  # Notify all signed-in users that someone joined
  Loco.emit({
    event: :member_joined,
    room_id: @room.id,
    member: { id: current_user.id, username: current_user.username }
  }, subject: @room, to: [User])

  redirect_to user_room_url(@room)
end

def leave
  hub = Loco.get_hub("room_#{@room.id}")

  hub.del_member(current_user)

  Loco.emit(@room, :member_left, payload: {
    room_id: @room.id,
    member: { id: current_user.id }
  }, to: [User])

  redirect_to user_rooms_path
end
```

### Front-end model

[Loco-JS-Model](https://github.com/locoframework/loco-js-model) lets you define JavaScript classes that mirror your Rails models. When a notification is emitted for `Room` on the server, subscribers of the `Room` JS class receive it:

```javascript
// frontend/js/models/Room.js

import { Models } from "loco-js-model";

class Room extends Models.Base {
  static identity = "Room"; // must match the Rails model name
}

export default Room;
```

### Front-end subscriber

Subscribe to `Room` notifications. The callback receives the event type (e.g., `"Room member_joined"`) and the payload sent from the server:

```javascript
// frontend/js/views/user/rooms/Show.js

import { subscribe } from "loco-js";
import Room from "models/Room";

const onMessage = (roomId) => (type, data) => {
  if (data.room_id !== roomId) return;

  switch (type) {
    case "Room member_joined":
      // add member to the list
      break;
    case "Room member_left":
      // remove member from the list
      break;
  }
};

subscribe({ to: Room, with: onMessage(roomId) });
```

See [test/dummy/](../test/dummy/) for the full working app.
