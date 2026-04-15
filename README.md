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

`loco:install` generates `config/initializers/loco.rb`:

```ruby
Loco.configure do |c|
  c.silence_logger = false          # mute Loco's logger (default: false)
  c.notifications_size = 100        # max notifications returned at once (default: 100)
  c.app_name = "loco_#{Rails.env}"  # Redis key prefix (default: 'loco')
  c.redis_instance = nil            # custom Redis instance (default: nil)
end
```

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
import { subscribe } from "loco-js";
import Article from "models/Article";

const receivedNotification = (type, payload) => {
  switch (type) {
    case "Article confirmed":
      // payload from the server
      break;
  }
};

subscribe({ to: Article, with: receivedNotification });
```

```ruby
receivers = [article.user, Admin, 'a54e1ef01cb9']
data = { foo: 'bar' }

Loco.emit(article, :confirmed, to: receivers, payload: data)
```

Arguments:

1. a resource this event relates to
2. a name of an event that occurred (Symbol/String). Default values are:
	* **:created** - when `created_at == updated_at`
	* **:updated** - when `updated_at > created_at`
3. a hash with relevant keys:
	* **:to** - message's recipients. It can be a single object or an array of objects. Instances of models, their classes, and strings are accepted. If a recipient is a class, then given notification is addressed to all instances of this class currently signed in. If a receiver is a string (token), clients will receive notifications who have subscribed to this token on the front-end side. They can do this by invoking this code: `getWire().token = "<token>";`
	* **:payload** - additional data, serialized to JSON, transmitted along with the notification

⚠️ If you wonder how to receive those notifications on the front-end side, look at the [proper section](https://github.com/locoframework/loco-js#-receiving-messages) of Loco-JS [README](https://github.com/locoframework/loco-js).

#### Garbage collection

When you emit a lot of notifications, you create a lot of records in the database. This way, your **loco_notifications** table may soon become very big. You must periodically delete old records. Below is a somewhat naive approach, but it works.

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

### `Loco.emit_to`

This module function emits a direct message to recipients. Direct messages are sent only via a WebSocket connection and are not persisted in a DB.

⚠️ It utilizes _ActionCable_ under the hood. You can use _ActionCable_ in a standard way and _Loco-way_ side by side. If you choose to stick to Loco only - you will never have to create `ApplicationCable::Channel`s. Remember that Loco places `ActiveJob`s into the `:loco` queue.

If you want to send a message to a group of recipients, persist this group, and have an ability to add/remove members - an entity called **Communication Hub** may be handy.

#### Communication Hub

You can treat it like a virtual room where you can add/remove members.
It works over WebSockets only with the `emit_to` module function.

`Loco` also provides hub management module functions such as `add_hub`, `get_hub`, `del_hub`.

Details:

* `add_hub(name, members = [])` - creates and returns an instance of `Loco::Hub` with a given name and members passed as a 2nd argument. In a typical use case - members should be an array of _ActiveRecord_ instances.

* `get_hub(name)` - returns an instance of `Loco::Hub` with a given name or `nil` if a hub does not exist.

* `del_hub(name)` - destroys an instance of `Loco::Hub` with a given name if it exists.

Important instance methods of `Loco::Hub`:

* `name`
* `members` - returns the hub's members. Members are stored in an informative, shortened form inside Redis. Be aware that this method performs calls to DB to fetch all members.
* `raw_members` - returns hub's members in the shortened form as they are stored: `"{class}:{id}"`
* `add_member(member)`
* `del_member(member)`
* `include?(member)`
* `destroy`

Example:

```ruby
hub1 = Hub.get('room_1')
admin = Admin.find(1)

data = { type: 'NEW_MESSAGE', message: 'Hi all!', author: 'system' }

Loco.emit_to([hub1, admin], data)
```

Arguments:

1. recipients - a single object or an array of objects. ActiveRecord instances and Communication Hubs are allowed.
2. data - a hash serialized to JSON during sending.

⚠️ Check out the [proper section](https://github.com/locoframework/loco-js#-receiving-messages) of Loco-JS [README](https://github.com/locoframework/loco-js) about receiving these messages on the front-end.

# 🚛 Receiving notifications sent over WebSockets

## Notification Center 🛰

You can send messages over a WebSocket connection from the browser to the server using the `emit` function. These messages can be received on the back-end by the `Loco::NotificationCenter` class located in *app/services/loco/notification_center.rb*

`loco:install` generator generates this class.

The `received_message` instance method is called automatically for each message sent by front-end clients. 2 arguments are passed:

1. a hash with resources that can sign in to your app. You define them as `loco_permissions` inside `ApplicationCable::Connection` class. The keys of this hash are lowercase class names of signed-in resources, and the values are the instances themselves.

2. a hash with sent data

You can look at the working example [here](https://github.com/locoframework/loco-rails/blob/master/test/dummy/app/services/loco/notification_center.rb).

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
