![logo](https://raw.githubusercontent.com/artofcodelabs/artofcodelabs.github.io/master/assets/ext/loco_logo_trans_sqr-300px.png)

> Rails is cool. But modern web needs Loco-motive.

# 🧐 What is Loco-Rails?

**Loco-Rails** is a lightweight [Rails engine](http://guides.rubyonrails.org/engines.html) for real-time communication between back-end and front-end.

```text
Loco
|
|--- Loco-Rails (back-end, this gem)
|
|--- Loco-JS (front-end)
        |
        |--- Loco-JS-Model (model layer, can be used standalone)
```

[**Loco-JS-Model**](https://github.com/locoframework/loco-js-model) lets you define JavaScript classes that mirror your Rails models (e.g., `Article`, `Comment`). Combined with [**Loco-JS**](https://github.com/locoframework/loco-js) and **Loco-Rails**, you subscribe to these front-end models and get notified in the browser when the corresponding record is created/updated on the server.

It allows you to:

- send messages over WebSockets in both directions with a single line of code on each side
- subscribe to front-end models — when a Rails record changes, subscribers are notified automatically
- persist notifications in the database so clients receive missed messages after reconnecting
- respect permissions — deliver messages only to recipients signed in as a given resource (e.g., a specific user or admin)
- group recipients into Communication Hubs (virtual rooms)

See [docs/EXAMPLES.md](docs/EXAMPLES.md) for a full chat room example showing back-end and front-end working together.

# 🤝 Dependencies

- Ruby >= 3.1.0
- Rails >= 7.1
- [Redis](http://redis.io) — stores WebSocket connection state. Not required if you don't use ActionCable.

# 📥 Installation

1️⃣ Add to your Gemfile:

```ruby
gem 'loco-rails'
```

2️⃣ Run:

```bash
bundle install
bin/rails generate loco:install
bin/rails db:migrate
```

3️⃣ Install the front-end part:

```bash
npm install loco-js --save
```

See [Loco-JS documentation](https://github.com/locoframework/loco-js#-installation) for front-end setup.

Keep the MAJOR version the same between Loco-Rails and Loco-JS to maintain compatibility.

_Look inside `test/dummy/` for a reference setup._

# ⚙️ Configuration

`loco:install` generates/injects four things you must review and customize:

## 1. `config/initializers/loco.rb`

```ruby
Loco.configure do |c|
  c.silence_logger = false          # mute Loco's logger (default: false)
  c.notifications_size = 100        # max notifications returned at once (default: 100)
  c.app_name = "loco_#{Rails.env}"  # Redis key prefix — keeps envs isolated (default: 'loco')
  c.redis_instance = nil            # reuse an existing Redis client instead of creating a new one (default: nil)
end
```

## 2. `ApplicationController#loco_permissions`

Tells Loco which signed-in resources exist in an HTTP request (used by the notification-polling endpoint). Return an array of method names that resolve to signed-in resources (e.g., `current_user`, `current_admin`). Must match what your auth layer exposes.

```ruby
def loco_permissions
  [current_user, current_admin]  # add/remove per your app's roles
end
```

## 3. `ApplicationCable::Connection#loco_permissions`

Same concept for the WebSocket connection. Loco identifies each connection by this array. **The first element must be `SecureRandom.uuid`** — it gives the connection a unique anonymous identity so Loco can:

- track connections that aren't tied to a signed-in user (token-based subscribers)
- route messages to the exact browser tab, not "all connections of user X"
- clean up stale connections in Redis by UUID

The rest of the array mirrors the signed-in resources from `ApplicationController`. Connections without any signed-in resource are rejected via `reject_unauthorized_connection`.

```ruby
identified_by :loco_permissions

def connect
  reject_unauthorized_connection unless current_user || current_admin
  self.loco_permissions = [SecureRandom.uuid, current_user, current_admin]
end

def current_admin
  defined?(Admin) && Admin.find_by(id: cookies.signed[:admin_id])
end

def current_user
  defined?(User) && User.find_by(id: cookies.signed[:user_id])
end
```

## 4. `app/services/loco/notification_center.rb`

Handler for messages sent **from the browser to the server** over WebSocket. Fill in `received_message` to route incoming messages. See the [Receiving messages from the front-end](#-receiving-messages-from-the-front-end) section below.

```ruby
module Loco
  class NotificationCenter
    def received_message(permissions, payload)
      # handle messages here
    end
  end
end
```

## 5. Routes

`loco:install` also mounts the engine for notification polling:

```ruby
mount Loco::Engine => '/notification-center'
```

This endpoint is hit when WebSocket is unavailable — clients fetch missed persisted notifications via HTTP.

# 🎮 Usage

## 📡 Emitting messages — `Loco.emit`

`Loco.emit` is the single entry point for sending messages. It supports two modes:

### Notification mode (persisted)

Emits a notification about a resource event (e.g., _the post was updated_, _the ticket was validated). If a WebSocket connection is established — message is sent this way. If not — it's delivered via AJAX polling. Switching between available methods is done automatically. Notifications are persisted in the `loco_notifications` table, so **clients receive missed messages after reconnecting**.

```ruby
Loco.emit(payload, to: [article.user, Admin, 'a54e1ef01cb9'], subject: article)
```

Arguments:

1. **payload** (required) — a Hash serialized to JSON. Two conventions for the message name:
    - `:event` — paired with `:subject` (ActiveRecord instance). Front-end receives `"{ModelName} {event}"` (e.g., `"User confirmed"`). Routed via `subscribe({ to: Model })` from [Loco-JS](https://github.com/locoframework/loco-js) using models defined with [Loco-JS-Model](https://github.com/locoframework/loco-js-model).
    - `:type` — convention when there is no model subject. Front-end receives the raw `type` string (e.g., `"USER_CONFIRMED"`). Typically dispatched in a central `NotificationCenter` switch.
1. Keyword arguments:
    - **`:to`** (required) — recipients. Single object or array. Accepts:
        - **model instance** (e.g., `user`) — delivers to that specific signed-in resource
        - **class** (e.g., `User`, `Admin`) — delivers to all signed-in instances of that class
        - **string token** (e.g., `'a54e1ef01cb9'`) — delivers to any front-end client that subscribed to that token via `getWire().token = "a54e1ef01cb9"`. Useful for anonymous/guest users or custom grouping without a Hub.
    - **`:subject`** (optional) — ActiveRecord instance the event relates to. When provided, its `id` is merged into the payload and the notification is routable via front-end model subscribers.

On the front-end, all messages (both `:event` and `:type` based) are routed through `NotificationCenter` — a central callback you pass during initialization:

```javascript
// frontend/js/initializers/loco.js

import { init } from "loco-js";
import { createConsumer } from "@rails/actioncable";
import Article from "models/Article";
import Room from "models/Room";

const loco = init({
  cable: createConsumer(),
  models: [Article, Room],
  notificationCenter: async (payload) => {
    switch (payload.type) {
      case "USER_CONFIRMED":           // :type message — no model subject
        window.location.href = "/user/sessions/new?event=confirmed";
        break;
      case "Article created":          // :event message — "{ModelName} {event}"
        handleArticleCreated(payload);
        break;
    }
  },
});

export default loco;
```

For model-specific subscriptions, you can also use `subscribe` from [Loco-JS](https://github.com/locoframework/loco-js) — useful when a view only cares about certain models. One callback can handle multiple models; the `type` string differentiates:

```javascript
import { subscribe } from "loco-js";
import Article from "models/Article";
import Comment from "models/Comment";

const receivedNotification = (type, payload) => {
  switch (type) {
    case "Article confirmed":
      break;
    case "Comment created":
      break;
  }
};

subscribe({ to: Article, with: receivedNotification });
subscribe({ to: Comment, with: receivedNotification });
```

See [Loco-JS — Receiving messages](https://github.com/locoframework/loco-js#-receiving-messages) for details.

### Direct mode (WebSocket only, not persisted)

Sends a message directly via WebSocket. Not stored in DB — if the client is offline, the message is lost.

```ruby
Loco.emit({ type: 'NEW_MESSAGE', message: 'Hi!' }, to: [hub, admin], ws_only: true)
```

⚠️ Loco uses ActiveJob (`:loco` queue) when broadcasting to a class (e.g., `to: [User]`) or to `:all` — these fan out to all connected clients of that type. When you target a specific user (e.g., `to: user`), the message is sent inline without a job. This is transparent — you use the same `Loco.emit` API either way.

## 🗑️ Garbage collection

Periodically delete old notifications to keep the `loco_notifications` table manageable:

```ruby
class GarbageCollectorJob < ApplicationJob
  queue_as :default

  after_perform do |job|
    GarbageCollectorJob.set(wait_until: 1.hour.from_now).perform_later
  end

  def perform
    Loco::Notification.where('created_at < ?', 1.hour.ago).find_each(&:destroy)
  end
end
```

## 🏘️ Communication Hubs

Virtual rooms for grouping recipients. Members stored in Redis. Hubs expand to their members when passed to `Loco.emit` — works in both persisted and `ws_only: true` modes.

```ruby
hub = Loco.add_hub('room_1', [user1, user2])  # create with members
hub = Loco.get_hub('room_1')                  # retrieve
Loco.del_hub('room_1')                        # destroy
```

Send a message to all hub members (plus any extra recipients):

```ruby
hub = Loco.get_hub('room_1')
admin = Admin.find(1)

Loco.emit(
  { type: 'NEW_MESSAGE', message: 'Hi all!', author: 'system' },
  to: [hub, admin]
)
```

Hub instance methods: `name`, `members`, `raw_members`, `add_member(member)`, `del_member(member)`, `include?(member)`, `destroy`

Note: `members` performs DB queries to fetch full objects. Use `raw_members` for the lightweight `"{class}:{id}"` form stored in Redis.

## 🛰 Receiving messages from the front-end

Messages sent from the browser via WebSocket are received by `Loco::NotificationCenter` (generated at `app/services/loco/notification_center.rb`).

The `received_message` instance method is called for each message with 2 arguments:

1. **permissions** — a hash of signed-in resources (keys: lowercase class names, values: instances), as defined in `ApplicationCable::Connection#loco_permissions`
2. **payload** — the sent payload

See [working example](https://github.com/locoframework/loco-rails/blob/master/test/dummy/app/services/loco/notification_center.rb).

# 👩🏽‍🔬 Tests

```bash
bundle install
docker compose up
bin/rails db:create
bin/rails test
```

# 📈 Changelog

## Major releases 🎙

### 7.0 _(2026-04)_

- **Breaking:** `Loco::Emitter` removed — use `Loco.emit`, `Loco.add_hub`, etc.
- New format: `Loco.emit(payload, to: recipients, ws_only: true, subject: target)`
- **Deprecation:** formats other than above will become unsupported in Loco-Rails 8
- **Deprecation:** `Loco.emit_to` will be removed in Loco-Rails 8

### 6.1 _(2022-09-04)_

- All `Loco::Emitter` methods available as `Loco` module functions
- **Deprecation:** `Loco::Emitter` will be removed in Loco-Rails 7

### 6.0 _(2022-02-03)_

- Rails 7 and Ruby 3.1 support
- Drops Ruby 2.6

### 5.0 _(2020-12-23)_

- **Breaking:** Redis required in dev env when using ActionCable
- **Breaking:** Internal Redis data structures changed — `FLUSHDB` recommended

### 4.0 _(2020-07-26)_

- **Breaking:** `received_signal` renamed to `received_message` in `NotificationCenter`
- **Breaking:** `Loco.configure` requires a block

# 📜 License

Loco-Rails is released under the [MIT License](https://opensource.org/licenses/MIT).

# 👨‍🏭 Author

Zbigniew Humeniuk from [Art of Code](http://artofcode.co)
