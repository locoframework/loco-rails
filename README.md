![logo](https://raw.githubusercontent.com/artofcodelabs/artofcodelabs.github.io/master/assets/ext/loco_logo_trans_sqr-300px.png)

> Rails is cool. But modern web needs Loco-motive.

# 🧐 What is Loco-Rails?

**Loco-Rails** is a [Rails engine](http://guides.rubyonrails.org/engines.html) from the technical point of view. Conceptually, it is a framework that works on a top of [Rails](http://rubyonrails.org) and consists of 2 parts: front-end and back-end. They are called [**Loco-JS**](https://github.com/locoframework/loco-js) and **Loco-Rails**, respectively. Both parts cooperate.

This is how it can be visualized:

```
Loco Framework
|
|--- Loco-Rails (back-end part)
|       |
|       |--- Loco-Rails-Core (logical structure for JS / can be used separately with Loco-JS-Core)
|
|--- Loco-JS (front-end part)
        |
        |--- Loco-JS-Core (logical structure for JS / can be used separately)
        |
        |--- Loco-JS-Model (model part / can be used separately)
        |
        |--- other built-in parts of Loco-JS

        Loco-JS-UI - connects models with UI elements (a separate library)
```

The following sections contain a more detailed description of its internals and API.

# ⛑ But how is Loco supposed to help?

* by providing a logical structure for a JavaScript code along with a base class for controllers. You exactly know where to start looking for a JavaScript code that runs a current page ([**Loco-JS-Core**](https://github.com/locoframework/loco-js-core/))
* you have models that protect API endpoints from sending invalid data. They also facilitate fetching objects of a given type from the server ([**Loco-JS-Model**](https://github.com/locoframework/loco-js-model/))
* you can easily assign a model to a form enriching this form with fields' validation ([**Loco-JS-UI**](https://github.com/locoframework/loco-js-ui/))
* you can subscribe to a model or a collection of models on the front-end by passing a function. Front-end and back-end models can be connected. This function is called when a notification for a given model is sent on the server-side. (**Loco**)
* it allows sending messages over WebSockets in both directions with just a single line of code on each side (**Loco**)
* it respects permissions. You can filter out sent messages if a sender is not signed in as a given resource, _for example, a given admin or user_) (**Loco**)

# 🚨 Other, more specific problems that Loco solves

## Current state everywhere

Let's assume, 2 users are navigating to a chat room page containing a list of chat members. This is a regular request-response application without technics like AJAX polling and WebSockets.

|  User A | User B |
|---|---|
| is joining a chat |---|
| --- | is joining a chat and is seeing User A who joined before |
| is not seeing User B on the list of chat members | is seeing User A and User B as chat members |
| **is refreshing a page** | is seeing User A and User B as chat members |
| is seeing User A and User B as chat members | is seeing User A and User B as chat members |

So, you have to constantly refresh a page to get the current list of chat members. Or you need to provide a _"live"_ functionality through AJAX or WebSockets. This requires a lot of unnecessary work/code for every element of your app like this. It should be much easier. And by easier, I mean ~1 significant line of code on the back-end and front-end side. Look for the `emit` method on the back-end and `subscribe` function on the front-end.

```ruby
# app/controllers/user/rooms_controller.rb

class User
  class RoomsController < UserController
    def join
      @hub.add_member current_user
      emit @room, :member_joined, data: {
        room_id: @room.id,
        member: {
          id: current_user.id,
          username: current_user.username
        }
      }
      redirect_to user_room_url(@room)
    end
  end
end
```

Below is how the front-end version of `Room` model can look like. If they share the same name, you can consider them as _"connected"_. Otherwise, you need to specify the mapping. For all the options, look at the Loco-JS-Model [documentation](https://github.com/locoframework/loco-js-model).

```javascript
// frontend/js/models/Room.js

import { Models } from "loco-js";

class Room extends Models.Base {
  static identity = "Room";

  constructor(data) {
    super(data);
  }
}

export default Room;
```

Below is an example of a view that always renders an up-to-date list of chat members.


```javascript
// frontend/js/views/user/rooms/Show.js

import { subscribe } from "loco-js";

import Room from "models/Room";

const memberJoined = member => {
  const li = `<li id='user_${member.id}'>${member.username}</li>`;
  document.getElementById("members").insertAdjacentHTML("beforeend", li);
};

const createReceivedMessage = roomId => {
  return function(type, data) {
    switch (type) {
      case "Room member_joined":
        if (data.room_id !== roomId) return;
        memberJoined(data.member);
        break;
    }
  };
};

export default {
  render: roomId => {
    subscribe({ to: Room, with: createReceivedMessage(roomId) });
  },

  renderMembers: members => {
    for (const member of members) {
      memberJoined(member);
    }
  }
};
```

This is just the tip of the iceberg. Look at [Loco-JS](https://github.com/locoframework/loco-js) and [Loco-JS-Model](https://github.com/locoframework/loco-js-model) documentation for more.

# 🤝 Dependencies

**Loco-JS**

* 🎊 no strict external dependencies. 🎉 But check out its [_"soft dependencies"_](https://github.com/locoframework/loco-js#-dependencies)❗️

**Loco-Rails**

* [Loco-Rails-Core](https://github.com/locoframework/loco-rails-core) - Rails plugin that has been extracted from Loco-Rails so it could be used as a stand-alone lib. It provides a logical structure for JavaScript code that corresponds with Rails` controllers and their actions that handle a given request. Loco-Rails-Core requires [Loco-JS-Core](https://github.com/locoframework/loco-js-core) to work.
* modern Ruby (tested on >= 2.3.0)
* Rails 5
* [Redis](http://redis.io) and [redis](https://github.com/redis/redis-rb) gem - Loco-Rails stores information about WebSocket connections in Redis. It is not required if you don't want to use ActionCable, or you use Rails in the development environment. In the last case - Loco-Rails uses an in-process data store or Redis (if available).

# 📥 Installation

To have Loco fully functional, you have to install both: back-end and front-end parts.

1️⃣ Loco-Rails works with Rails 5 onwards. You can add it to your Gemfile with:

```ruby
gem 'loco-rails'
```

At the command prompt run:

```bash
$ bundle install
$ bin/rails generate loco:install
$ bin/rails db:migrate
```

2️⃣ Now it's time for the front-end part. Install it using npm (or yarn):

```bash
$ npm install loco-js --save
```

Familiarize yourself with the [proper sections](https://github.com/locoframework/loco-js#-installation) from the [Loco-JS documentation](https://github.com/locoframework/loco-js) on how to set up everything on the front-end side.

_Look inside `test/dummy/` to check a recommended setup with the [webpack](https://webpack.js.org)._

Loco-Rails and Loco-JS both use Semantic Versioning (MAJOR.MINOR.PATCH).  
It is required to keep the MAJOR version number the same between Loco-Rails and Loco-JS to maintain compatibility.

Some features may require an upgrade of MINOR version both for front-end and back-end parts. Check Changelogs and follow our [Twitter](https://twitter.com/artofcode_co) to be notified.

# ⚙️ Configuration

1️⃣ `loco:install` generator creates `config/initializers/loco.rb` file (among other things) that holds configuration:

```ruby
# frozen_string_literal: true

Loco.configure do |c|
  c.silence_logger = false          # false by default
  c.notifications_size = 10         # 100 by default
  c.app_name = "loco_#{Rails.env}"  # your app's name (required for namespacing)
end
```

Where:

* notifications_size - max number of notifications returned from the server at once
* app_name - used as key's prefix to store info about current WebSocket connections in Redis or memory

In a production environment - it's better not to store all the data Loco-Rails needs to work in memory. A better option is Redis, which is shared between app servers.  
If Loco-Rails discovers Redis instance under `Redis.current`, it will use it. Except that, you can specify Redis instance directly using `redis_instance: Redis.new(your_config)`.

2️⃣ Browse all generated files and customize them according to the comments.

# 🎮 Usage

## Emitting messages 📡

1. include `Loco::Emitter` module inside any class
2. use `emit` or `emit_to` methods provided by this module to send a different type of messages 

If you want to use a `low-level` interface without including a module, look inside the source code of [`Loco::Emitter`](https://github.com/locoframework/loco-rails/blob/master/lib/loco/emitter.rb).

### `emit`

This method emits a notification that informs recipients about an event that occurred on the given resource - e.g., _the post was updated_, _the ticket was validated_. If a WebSocket connection is established - a message is sent this way. If not - it's delivered via AJAX polling. Switching between an available method is done automatically.

Notifications are stored in the *loco_notifications* table in the database. One of the advantages of saving messages in a DB is that **when the client loses connection with the server and restores it after a certain time - he will get all not received notifications** 👏 unless you delete them before, of course.

Example:

```ruby
include Loco::Emitter

receivers = [article.user, Admin, 'a54e1ef01cb9']
data = { foo: 'bar' }

emit(article, :confirmed, to: receivers, data: data)
```

Arguments:

1. a resource this event relates to
2. a name of an event that occurred (Symbol/String). Default values are:
	* **:created** - when `created_at == updated_at`
	* **:updated** - when `updated_at > created_at`
3. a hash with relevant keys:
	* **:to** - message's recipients. It can be a single object or an array of objects. Instances of models, their classes, and strings are accepted. If a recipient is a class, then given notification is addressed to all instances of this class currently signed in. If a receiver is a string (token), clients will receive notifications who have subscribed to this token on the front-end side. They can do this by invoking this code: `getWire().token = "<token>";`
	* **:data** - additional data, serialized to JSON, transmitted along with the notification

⚠️ If you wonder how to receive those notifications on the front-end side, look at the [proper section](https://github.com/locoframework/loco-js#-receiving-messages) of Loco-JS [README](https://github.com/locoframework/loco-js).

#### Garbage collection

When you emit a lot of notifications, you create a lot of records in the database. This way, your **loco_notifications** table may soon become very big. You must periodically delete old records. Below is a somewhat naive approach, but it works.

```ruby
# frozen_string_literal: true

class GarbageCollectorJob < ApplicationJob
  queue_as :default

  after_perform do |job|
    GarbageCollectorJob.set(wait_until: 1.hour.from_now).perform_later
  end

  def perform
    Loco::Notification.where('created_at < ?', 1.hour.ago)
                      .find_each(&:destroy)
  end
end

```

### `emit_to`

This method emits a direct message to recipients. Direct messages are sent only via WebSocket connection and are not persisted in a DB.

⚠️ It utilizes _ActionCable_ under the hood. You can use _ActionCable_ in a standard way and _Loco-way_ side by side. If you choose to stick to Loco only - you will never have to create `ApplicationCable::Channel`s. Remember that Loco places `ActiveJob`s into the `:loco` queue.

If you want to send a message to a group of recipients, persist this group, and have an ability to add/remove members - an entity called **Communication Hub** may be handy.

#### Communication Hub

You can treat it like a virtual room where you can add / remove members.  
It works over WebSockets only with the `emit_to` method.

Methods for managing hubs such as `add_hub`, `get_hub`, `del_hub` are also included in [`Loco::Emitter`](https://github.com/locoframework/loco-rails/blob/master/lib/loco/emitter.rb) module.

Details:

* `add_hub(name, members = [])` - creates and then returns an instance of `Loco::Hub` with given name and members passed as a 2nd argument. In a typical use case - members should be an array of _ActiveRecord_ instances.

* `get_hub(name)` - returns an instance of `Loco::Hub` with a given name that was created before. If hub does not exist - returns `nil`.

* `del_hub(name)` - destroys an instance of `Loco::Hub` with a given name if exists.

Important instance methods of `Loco::Hub`:

* `name`
* `members` - returns hub's members. Members are stored in an informative, shortened form inside Redis / in-process storage, so be aware that this method performs calls to DB to fetch all members.
* `raw_members` - returns hub's members in the shortened form as they are stored: `"{class}:{id}"`
* `add_member(member)`
* `del_member(member)`
* `include?(member)`
* `destroy`

Example:

```ruby
include Loco::Emitter

hub1 = Hub.get('room_1')
admin = Admin.find(1)

data = { type: 'NEW_MESSAGE', message: 'Hi all!', author: 'system' }

emit_to([hub1, admin], data)
```

Arguments:

1. recipients - single object or an array of objects. ActiveRecord instances and Communication Hubs are allowed.
2. data - a hash serialized to JSON during sending.

⚠️ Check out the [proper section](https://github.com/locoframework/loco-js#-receiving-messages) of Loco-JS [README](https://github.com/locoframework/loco-js) about receiving those messages on the front-end.

# 🚛 Receiving notifications sent over WebSockets

## Notification Center 🛰

You can send messages over WebSocket connection from the browser to the server using `Env.loco.emit({})`. These messages can be received on the back-end by the `Loco::NotificationCenter` class located in *app/services/loco/notification_center.rb*

This class is generated when you run `loco:install` generator.

The `received_message` instance method is called automatically for each message sent by front-end clients. 2 arguments are passed:

1. a hash with resources that are able to sign-in to your app. You define them as `loco_permissions` inside `ApplicationCable::Connection` class. The keys of this hash are lowercase class names of signed-in resources and the values are the instances themselves.

2. a hash with sent data

You can look at the working example [here](https://github.com/artofcodelabs/rails-modern-front-end/commit/1d584893031b68bb9d29c5f2c8dbd1a423957a5b#diff-32aaf7d5c1f91a074cc09737ab1c402b).

# 👩🏽‍🔬 Tests

```bash
bin/rails test
```

Integration tests are powered by Capybara. Capybara is cool but sometimes random tests fail unexpectedly. So before you assume that something is wrong, just run failed tests separately. It definitely helps to keep focus on the browser's window that runs integration tests on macOS.

# 📈 Changelog

## Major releases 🎙

### 3.0

* Loco-JS and Loco-JS-Model are no longer distributed with Loco-Rails and have to be installed using `npm`
* all generators, generating legacy `CoffeeScript` code, have been removed

### 2.2

* Loco-JS and Loco-JS-Model have been updated

### 2.0

* changes in the front-end architecture - Loco-JS-Model has been extracted from Loco-JS

### 1.5

* Loco-JS dropped the dependency on jQuery. So it officially has no dependencies 🎉

### 1.4

* Ability to specify Redis instance through configuration

### 1.3

* `emit_to` - send messages to chosen recipients over WebSocket connection (an abstraction on the top of `ActionCable`)

* Communication Hubs - create *virtual rooms*, add members and `emit_to` these hubs messages using WebSockets. All in 2 lines of code!

* now `emit` uses WebSocket connection by default (if available). But it can automatically switch to AJAX polling in case of unavailability. And all the notifications will be delivered, even those that were sent during this lack of a connection. 👏 If you use `ActionCable` solely and you lost connection to the server, then all the messages that were sent in the meantime are gone 😭.

🔥 Only version 3 is under support and development.

Informations about all releases are published on [Twitter](https://twitter.com/artofcode_co)

# 📜 License

Loco-Rails is released under the [MIT License](https://opensource.org/licenses/MIT).

# 👨‍🏭 Author

Zbigniew Humeniuk from [Art of Code](http://artofcode.co)
