![logo](https://raw.githubusercontent.com/artofcodelabs/artofcodelabs.github.io/master/assets/ext/loco_logo_trans_sqr-300px.png)

> Rails is cool. But modern web needs Loco-motive.

# 🧐 What is Loco-Rails?

**Loco-Rails** is a [Rails engine](http://guides.rubyonrails.org/engines.html) from the technical point of view. Conceptually, it is a framework that works on a top of [Rails](http://rubyonrails.org) and consists of 2 parts: front-end and back-end. They are called [**Loco-JS**](https://github.com/locoframework/loco-js) and **Loco-Rails**, respectively. Both parts cooperate with each other.

This is how it can be visualized:

```
Loco Framework
|
|--- Loco-Rails (back-end part)
|       |
|       |--- Loco-Rails-Core (logical structure for JS / can be used separately with Loco-JS)
|
|--- Loco-JS (front-end part / can be used separately)
        |
        |--- Loco-JS-Model (model part / can be used separately)
        |
        |--- other parts of Loco-JS
```

Following sections contain more detailed description of its internals and API.

# ⛑ But how is Loco supposed to help?

* by providing logical structure for a JavaScript code (along with base classes for models, controllers and views). You exactly know where to start, when looking for a JavaScript code that runs current page ([**Loco-Rails-Core**](https://github.com/locoframework/loco-rails-core) along with [**Loco-JS**](https://github.com/locoframework/loco-js))
* you have models that protect from sending invalid data to the API endpoints. They also facilitate fetching objects of a given type from the server ([**Loco-JS-Model**](https://github.com/locoframework/loco-js-model/))
* you can easily assign a model to a form what will enrich this form with fields' validation ([**Loco-JS**](https://github.com/locoframework/loco-js))
* you can connect models with controllers and views on the front-end. And they will be notified about every change made to a corresponding model on the server side. This change will be emitted as a signal to the front-end code. And signal is just a fancy name for a JS object (**Loco**)
* it allows you to send messages over WebSockets in both directions with just a single line of code on each side (**Loco**)
* respects permissions (you can send messages only to specified, signed in on the server models _e.g. given admin or user_) (**Loco**)
* solves other common problems

# 🚨 Other, more specific problems that Loco solves

## Current state everywhere

Let's assume, that we have 2 browsers open on the page with a list of articles.

|  Browser A | Browser B |
|---|---|
| edit article 1 | ----- |
| new version of article 1 is visible | old version of article 1 is visible |
| ----- | refresh page |
| new version of article 1 is visible | new version of article 1 is visible |

So, you have to constantly refresh the page to get the current list of articles. Or you need to provide, as a developer, a _"live"_ functionality through AJAX or WebSockets. This requires a lot of unnecessary work / code for every element of your app like this one. It should be much easier. And by easier, I mean ~1 significant line of code on the server and front-end side.  
With Loco you can solve this problem like this:

```ruby
# app/controllers/user/articles_controller.rb

class User::ArticlesController < UserController
  def update
    if @article.update article_params
      emit @article, :updated  # this 1 line on the server side emits a notification
                               # to all JavaScript objects that are connected
                               # with this particular instance of Article model
                               # or with the all instances of Article
      # ...
    end
  end
end
```

This is how the front-end version of Article model can look like. If they share the same name, you can consider them as _"connected"_. Otherwise, you need to specify the mapping. For all the options, look at the Loco-JS-Model [documentation](https://github.com/locoframework/loco-js-model).

```javascript
// frontend/javascripts/models/Article.js

import { Models } from "loco-js";

class Article extends Models.Base {
  static identity = "Article";

  static resources = {
    url: "/user/articles"
  };

  static attributes = {
    title: {
      type: "String",
      validations: {
        presence: true,
      }
    },
    content: {
      type: "String",
      validations: {
        presence: true,
      }
    }
  };

  constructor(data = {}) {
    super(data);
  }
}

export default Article;
```
Below is an example of a view that renders always up-to-date list of articles.

```javascript
// frontend/javascripts/views/main/pages/ArticleList.js

import { Views } from "loco-js";

import Article from "models/Article";

class ArticleList extends Views.Base {
  // ...
  
  render(articles) {
    this.renderArticles(articles);
    this.connectWith([Article]); // this line means: call "receivedSignal" method for every
                                 // signal emitted from the back-end and related to
                                 // any instance of Article model. This is because of Article
                                 // models on the back-end and front-end are "connected"
  }

  receivedSignal(signal, data) {
    switch (signal) {
      case "Article updated":
        // Loco-JS-Model delivers methods for fetching resources
        Article.find({id: data.id}).then(article => this.renderArticle(article));
      break;
      default:
    }
  }
}

export default ArticleList;
```

This is just the tip of the iceberg, look at [Loco-JS](https://github.com/locoframework/loco-js) and [Loco-JS-Model](https://github.com/locoframework/loco-js-model) documentations for more.

# 🎪 Demo (ver. 1.0)

[![Loco: demo](http://img.youtube.com/vi/05iJNyIKZZU/0.jpg)](http://www.youtube.com/watch?v=05iJNyIKZZU)

# 🦕 Origins

**Loco** framework was created back in 2016. The main reason for it was a need to make my life easier as a full-stack developer.
I was using [Coffeescript](http://coffeescript.org) on the front-end back then and [Ruby on Rails](http://rubyonrails.org) on the back-end.

I still use **Rails** but my front-end toolbox has changed a lot. Now, I work with modern goodies such as **ES6**, [Webpack](https://webpack.js.org), [Babel](https://babeljs.io), [React](https://reactjs.org), [Redux](https://redux.js.org)... and [**Loco-JS**](https://github.com/locoframework/loco-js) obviously :)

**Loco-Rails** enriches Ruby on Rails. It's a functionality layer that works on top of Rails to simplify communication between front-end na back-end code. It is a concept that utilizes good parts of Rails to make this communication straightforward.

But [**Loco-JS**](https://github.com/locoframework/loco-js) can be used as a standalone library to structure a JavaScript code, for example.  
[**Loco-JS-Model**](https://github.com/locoframework/loco-js-model/) can be used without Rails as well and in cooperation with other modern tools such as React and Redux. You have to follow only a few rules of formatting JSON responses from the server.

# 🤝 Dependencies

**Loco-JS**

* 🎊 no external strict dependencies. 🎉 But check out its [_"soft dependencies"_](https://github.com/locoframework/loco-js#-dependencies)❗️

**Loco-Rails**

* [Loco-Rails-Core](https://github.com/locoframework/loco-rails-core) - Rails plugin that has been extracted from Loco-Rails so it could be used as a stand-alone lib. It provides a logical structure for JavaScript code that corresponds with Rails` controllers and their actions that handle a given request. Loco-Rails-Core requires [Loco-JS](https://github.com/locoframework/loco-js) to work.
* modern Ruby (tested on >= 2.3.0)
* Rails 5
* [Redis](http://redis.io) and [redis](https://github.com/redis/redis-rb) gem - Loco-Rails stores informations about WebSocket connections in Redis. It is not required if you don't want to use ActionCable or you use Rails in development environment. In the last case - Loco-Rails uses in-process data store or Redis (if available).

# 📥 Installation

To have Loco fully functional you have to install both: back-end and front-end parts.

1️⃣ Loco-Rails works with Rails 4.2 onwards. You can add it to your Gemfile with:

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

_Look inside `test/dummy/` to see how to configure npm with Rails._

_Additionally, you can look at how to add Loco framework to the [**existing project**🔥](https://github.com/artofcodelabs/rails-modern-front-end). [This commit](https://github.com/artofcodelabs/rails-modern-front-end/commit/1d584893031b68bb9d29c5f2c8dbd1a423957a5b) is significant._

Loco-Rails and Loco-JS both use Semantic Versioning (MAJOR.MINOR.PATCH).  
It is required to keep the MAJOR version number the same between Loco-Rails and Loco-JS to keep compatibility.

Some features may require an upgrade of MINOR version both for front-end and back-end parts so check this out reading Changelogs and follow our [Twitter](https://twitter.com/artofcode_co).

# ⚙️ Configuration

1️⃣ `loco:install` generator creates `config/initializers/loco.rb` file (among other things) that holds configuration:

```ruby
# frozen_string_literal: true

Loco::Config.configure(
  silence_logger: false,        # false by default
  notifications_size: 100,      # 100 by default
  app_name: "loco_#{Rails.env}" # your app's name (required for namespacing)
)
```

Where:

* notifications_size - max number of notifications / signals returned from the server at once
* app_size - used as key's prefix to store info about current WebSocket connections in Redis or a memory

In a production environment - you'd probably prefer not to store all the data needed for Loco-Rails to work in a memory, but in Redis, which is shared between app servers.  
If Loco-Rails discovers Redis instance under `Redis.current`, it will use it. Except that, you can specify Redis instance directly using `redis_instance: Redis.new(your_config)`.

2️⃣ Browse all generated files and customize them according to the comments.

# 🎮 Usage

## Emitting signals 📡

1. include `Loco::Emitter` module inside any class
2. use `emit` or `emit_to` methods that this module provides to emit various types of signals 

If you want to use `low-level` interface without including a module, just look inside the source code of [`Loco::Emitter`](https://github.com/locoframework/loco-rails/blob/master/lib/loco/emitter.rb).

### `emit`

This method emits a signal that informs recipients about an event that occurred on the given resource e.g. _post was updated_, _ticket was validated_... If a WebSocket connection is established - the signal is sent this way. If not - it's delivered via AJAX polling. Switching between available method is done automatically.

Signals are stored in the *loco_notifications* table in the database. One of the advantages of saving signals in a DB is - **when client loses connection with the server and restores it after a certain time - he will get all not received notifications** 👏. Unless you delete them before, of course.

Example:

```ruby
include Loco::Emitter

receivers = [article.user, Admin, 'a54e1ef01cb9']
data = {foo: 'bar'}

emit article, :confirmed, for: receivers, data: data
```

Arguments:

1. a resource that emits an event
2. a name of an event that occurred (Symbol / String). Default values are:
	* **:created** - when created\_at == updated\_at
	* **:updated** - when updated\_at > created\_at
3. a hash with relevant keys:
	* **:for** - signal's recipients. It can be a single object or an array of objects. Instances of models, their classes and strings are accepted. If a recipient is a class, then given signal is addressed to all instances of this class that are currently signed in. If a receiver is a string (token), then clients who have subscribed to this token on the front-end side, will receive notifications. They can do this by invoking this code: `Env.loco.getWire().setToken("<token>");`
	* **:data** - additional data, serialized to JSON, that are transmitted along with the notification

⚠️ If you are wondering how to receive those signals on the front-end side, look at the [proper section](https://github.com/locoframework/loco-js#-connectivity) of Loco-JS [README](https://github.com/locoframework/loco-js).

#### Garbage collection

When you emit a lot of notifications, you obviously create a lot of records in the database. In this way, your **loco_notifications** table may soon become very big. You must periodically delete old records. Below is a rather naive approach, but it works.

```ruby
# frozen_string_literal: true

class GarbageCollectorJob < ApplicationJob
  queue_as :default

  after_perform do |job|
    GarbageCollectorJob.set(wait_until: 1.hour.from_now).perform_later
  end

  def perform
    Loco::Notification.where('created_at < ?', 1.hour.ago)
                      .find_in_batches do |batch|
                        batch.each(&:destroy)
                      end
  end
end

```

### `emit_to`

This method emits a signal that is a direct message to recipients. Direct messages are sent only via WebSocket connection and are not persisted in a DB.

⚠️ It utilizes _ActionCable_ under the hood. It is an additional layer on top that simplifies the work with WebSockets. You can use _ActionCable_ in a standard way and _Loco-way_ side by side. If you choose to stick to Loco only - you will never have to create `ApplicationCable::Channel`s. Just remember that Loco places `ActiveJob`s into the `:loco` queue.

If you want to send a message to a group of recipients, persist them and have an ability to add / remove members - an entity called **Communication Hub** may be handy.

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

hub1 = get_hub 'room_1'
admin = Admin.find 1

data = {signal: 'message', message: 'Hi all!', author: 'system'}

emit_to [hub1, admin], data
```

Arguments:

1. recipients - single object or an array of objects. ActiveRecord instances and Communication Hubs are allowed.
2. data - a hash serialized to JSON during sending.

⚠️ Check out the [proper section](https://github.com/locoframework/loco-js#-line) of Loco-JS [README](https://github.com/locoframework/loco-js) about receiving those signals on the front-end.

# 🚛 Receiving notifications sent over WebSockets

## Notification Center 🛰

You can send messages over WebSocket connection from the browser to the server using `Env.loco.emit({})`. These messages can be received on the back-end by the `Loco::NotificationCenter` class located in *app/services/loco/notification_center.rb*

This class is generated when you run `loco:install` generator.

The `received_signal` instance method is called automatically for each message sent by front-end clients. 2 arguments are passed:

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

* now `emit` uses WebSocket connection by default (if available). But it can automatically switch to AJAX polling in case of unavailability. And all the signals will be delivered, even those that were sent during this lack of a connection. 👏 If you use `ActionCable` solely and you lost connection to the server, then all the messages that were sent in the meantime are gone 😭.

🔥 Only version 3 is under support and development.

Informations about all releases are published on [Twitter](https://twitter.com/artofcode_co)

# 📜 License

Loco-Rails is released under the [MIT License](https://opensource.org/licenses/MIT).

# 👨‍🏭 Author

Zbigniew Humeniuk from [Art of Code](http://artofcode.co)
