![logo](https://raw.githubusercontent.com/artofcodelabs/artofcodelabs.github.io/master/assets/ext/loco_logo_trans_sqr-300px.png)

# 🚧 This documentation is under construction. Come back soon! 🚧

> Rails is cool. But modern web needs Loco-motive.

# 🧐 What is Loco-Rails?

**Loco-Rails** is a [Rails engine](http://guides.rubyonrails.org/engines.html) from the technical point of view. Conceptually, it is a framework that works on a top of [Rails](http://rubyonrails.org) and consists of 2 parts: front-end and back-end. They are called [**Loco-JS**](https://github.com/locoframework/loco-js) and **Loco-Rails**, respectively. Both parts cooperate with each other.

This is how it can be visualized:

```
Loco Framework
|
|--- Loco-Rails (back-end part)
|
|--- Loco-JS (front-end part / can be used separately)
        |
        |--- Loco-JS-Model (model part / can be used separately)
        |
        |--- other parts of Loco-JS
```

Following sections contain more detailed description of its internals and API.

# ⛑ But how is Loco supposed to help?

* by providing logical structure for a JavaScript code (along with base classes for models, controllers and views). You exactly know where to start, when looking for a JavaScript code that runs current page ([**Loco-JS**](https://github.com/locoframework/loco-js))
* you have models that protect from sending invalid data to the API endpoints. They also facilitate fetching objects of given type from the server ([**Loco-JS-Model**](https://github.com/locoframework/loco-js-model/))
* you can easily assign a model to a form what will enrich it with fields' validation ([**Loco-JS**](https://github.com/locoframework/loco-js))
* you can connect models with controllers and views on the front-end. And they will be notified about every change made to a corresponding model on the server side. This change will be emitted as a signal to the front-end code. And signal is just a fancy name for a JS object (**Loco**)
* it allows you to send messages over WebSockets in both directions with just a single line of code on each side (**Loco**)
* respects permissions (you can send messages only to specified, signed in on the server models _e.g. given admin or user_) (**Loco**)
* solves other common problems

# 🚨 Other, more specific problems that Loco solves

...

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

Signals are stored in the **loco_notifications** table in the database. One of the advantages of saving signals in a DB is - when client loses connection with the server and restores it after a certain time - he will get all not received notifications. Unless you delete them before, of course.

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
	* **:for** - signal's recipients. It can be a single object or an array of objects. Instances of models, their classes and strings are accepted. If a recipient is a class, then given signal is addressed to all instances of this class. If a receiver is a string (token), then clients who have subscribed to this token on the front-end side, will receive notifications. They can do this by invoking this code: `Env.loco.getWire().setToken("<token>");`
	* **:data** - additional data, serialized to JSON, that are transmitted along with the notification

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

⚠️ If you are wondering how to receive those signals on the front-end side, look at the [proper section](https://github.com/locoframework/loco-js#-connectivity) of Loco-JS [README](https://github.com/locoframework/loco-js).

### `emit_to`

This method emits a signal that is a direct message to recipients. Direct messages are sent only via WebSocket connection and are not persisted in a DB.

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

# ⬇️ Previous doc

## Loco-Rails

It allows you to simply send notifications from any part of a system, directly to associated JavaScript objects.

Following example presents a simple ActiveJob class that `emit`s *notifications / signals* directy to *associated* JavaScript objects.

By *associated objects*, I mean - first and foremost - the JavaScript equivalent of a given ActiveRecord class. It inherits from `App.Models.Base` and has the same name as given *ActiveRecord* class (in the most basic but recommended situation). I like to call them: **big brother and little brother** (better described in a section below). Each instance of *little brother JS class* is also auto connected with the corresponding instance of ActiveRecord class (based on ID). Also - all instances of JavaScript controllers and views, that have called `connectWith` method, will automatically receive emitted *signal / notification* for all objects they have connected with.

```ruby
class ArticleJob < ActiveJob::Base
  include Loco::Emitter

  queue_as :default

  def perform article
    article.update_attribute :verified, true
    emit article, :updated, data: {}, for: article.user  # warning - magic here!
  end
end
```

So, only one line of code is enough (`emit` method) to *magically* send notifications to all connected JavaScript objects in the browser. What's more - only author of this article will receive notification. You can pass an array of objects as receivers, also. Those objects can be instances of ActiveRecord classes or the classes themselves (example below).

```ruby
emit article, :created, for: [Admin, article.user]
```

In this example - both: an author of the article and all signed in admins will receive signal. Is it available out of the box? Yes, almost.. Just put this method into the `ApplicationController`:

```ruby
def loco_permissions
  # specify an array of method names which you use to determine
  # if given resource is signed-in
  # e.g.
  # [current_user, current_admin]
  [current_user, current_admin]
end
```

`loco:install` generator will take care of this automatically.

# 🏆 Main features

In terms of the whole system, the most important ones are the following:

### 2. Big brother and little brother

Here is a big brother:

```ruby
class Article < ActiveRecord::Base
  validates :title, presence: true, length: {minimum: 3, maximum: 255}
  validates :text, presence: true, length: {minimum: 100}

  validate :vulgarity_level

  private

    def vulgarity_level
      if vulgar?  # not implemented
        errors.add :base, "Article contains strong language."
      end
    end
end
```
And a little brother is right here:

```coffeescript
class App.Models.Article extends App.Models.Base
  @identity = "Article"
  @resources =
    url: '/user/articles', paginate: {per: 100}
    main:
      url: '/articles', paginate: {per: 10}

  @attributes =
    title:
      validations:
        presence: true
        length: {within: [3, 255]}
    content:
      validations:
        presence: true
        length: {minimum: 100}
      remoteName: "text"

  @validate = ["vulgarityLevel"]

  constructor: (data) -> super data

  vulgarityLevel: ->
    if this._isVulgar()  # not implemented
      this.addErrorMessage "Article contains strong language.", for: 'base'
```

Look at those two. Aren't they similiar? This is how both models are look like. You should be pretty familiar with the big one. But the little brother shouldn't provide you difficulties to unravel him also. Front-end model is described in a more detailed way, at the proper [place](http://github.com/locoframework/loco-js). Let's get right to the magic. You can place a line like this somewhere in a JS controller, for example:

```coffeescript
App.Models.Article.get('all', resource: 'main').then (resp) -> resp.resources
```

So what this line actually do? Let's suppose that we have 104 records in the `articles` table on the server. This code makes 11 requests to `/articles.json`. Then, initializes 104 instances of `App.Models.Article`, based on JSON responses. Finally, it returns an object with 2 properties: **resources** and **count**. **resources** is an array of `App.Models.Article` instances and **count** is a total number of articles in the database. As you can see - Loco-JS' API is based on [Promises](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Promise).

Rails controller is rather plain:

```ruby
class Main::ArticlesController < MainController
  def index
    @articles = Article.order("created_at DESC").paginate page: params[:page], per_page: 10
    @count = Article.count
  end
end
```

View is a standard Jbuilder template (*index.json.jbuilder*):

```ruby
json.resources @articles do |article|
  json.id article.id
  json.title article.title
  json.text article.text
end
json.count @count
```

That's all what you need to create a communication between little and big brother. And you should know that there is much more to communicate.

### 3. Current state everywhere

Let's assume, that we have 2 browsers open on the page with a list of articles.

|  Browser A | Browser B |
|---|---|
| edit article 1 | ----- |
| new version of article 1 is visible | old version of article 1 is visible |
| ----- | refresh page |
| new version of article 1 is visible | new version of article 1 is visible |

So, you need to constantly refresh page to get an actual list of articles. Or you need to provide, as developer, some *"live"* functionality through AJAX or WebSockets. This requires a lot of unnecessary work/code for an every each element of your app like that. It should be much easier. And by easier, I mean ~1 significant line of code on the server and front-end side. With Loco you can solve this problem like the following code presents:

```ruby
# app/controllers/user/articles_controller.rb
class User::ArticlesController < UserController
  def update
    if @article.update article_params
      emit @article, :updated  # 1 line on server side
      # ...
    end
  end
end
```

```coffeescript
# app/assets/javascripts/views/main/pages/article_list.coffee
class App.Views.Main.Pages.ArticleList extends App.Views.Base
  # ...

  receivedSignal: (signal, data) ->
    switch signal
      when 'Article updated'
        App.Models.Article.find(id: data.id).then (article) =>
          this._renderArticle article  # you could write this 3 lines as 1 longer ;)
```

### 4. Dashboard problem

A lot of applications have dashboard, which presents informations about many resources. It would be good, if presented information was up to date.

In the *"standard"* approach - controller's action renders full page. If your dashboard has some dynamic elements, like charts for example - you need to hide raw data in **data attributes** or do some *spaghetti code*. It's  ingredients are Ruby and JavaScript. It's not recommended, but I think that everyone has prepared at least one dish like this ;-) Then, you need to ask front-end guys to process data and generate required dynamic views. They'll put JavaScript code in a place known only to them, inside JavaScipt module or something... Then, they'll write (somewhere) code that fetches fresh data for every resource. You have to write API endpoints.

It's also worth considering to write a single API endpoint for all resources and bundle all data inside a custom structure. Of course, this approach will require time to consider, implement and document or explain to front-end fellas.

One dashboard - many problems. That's not all, though. Here is another one - let's check how the controller's action, that renders a dashboard, could look like in the *"standard"* approach:

```ruby
def dashboard
  @users_data = User.data_for_dashoard
  @articles_data = Article.data_for_dashoard
  @comments_data = Comment.data_for_dashboard
  # ...
end
```

It's an approximation of course, but it tells us: more data on dashboard page - probably longer response time. You cound experiment with Redis, but it's just another layer of complexity. Following animation shows, how rendering page this way is look like:

![standard rendering](https://raw.githubusercontent.com/artofcodelabs/artofcodelabs.github.io/master/assets/ext/1.gif)

You can see that it affects UX significantly.

Another approach is to render static page or very light and fast page (with placeholders for example). Then, transfer logic responsible for fetching and presenting data to proper abstract JavaScript views. How you'll organize code is up to you. You can have main view with subviews or just few equivalent views. Simpler is better. How to notify front-end code about new events? Do you remember `emit` method? So just `emit` signal on the server-side and receive it by all *connected* JavaScript objects. And you already know, where the JavaScript logic is located. Here is how rendering page this way is look like:

![async rendering](https://raw.githubusercontent.com/artofcodelabs/artofcodelabs.github.io/master/assets/ext/2.gif)

Intresting fact is that you can cover loading time with animations. When user see changes, he doesn't feel waiting. It should be really fast, though, cause we've split long action into a few fast ones. So it has server-side benefits, also.

Of course, we are not exempt from implementing API endpoints. But if you just need to return models, you can achieve this really easily. For the purpose of this example, let's assume that we want to show the most popular 10 comments in the comments view/widget. From the front-end perspective, we can fetch popular comments with just 1 line:

```coffescript
App.Models.Comment.get('popular', page: 1).then (resp) -> resp.resources
```

This line makes GET request to `/comments/popular` (let's simplify that), so we need to implement `popular` method in the `CommentsController`.

```ruby
class CommentsController < ApplicationController
  def popular
    @comments = Comment.order("likes DESC").paginate({
      page: params[:page],
      per_page: 10
    })
    @count = Comment.count
  end
end
```

And the view (*comments/popular.json.jbuilder*) could look like this:

```ruby
json.resources @comments do |comment|
  json.id comment.id
  json.author comment.author
  json.text comment.text
  json.article_id comment.article_id
  json.created_at comment.created_at
  json.updated_at comment.updated_at
end
json.count @count
```

Loco-JS requires from you to return a JSON response with a structure like this (*up*) - **resources** and **count** keys are mandatory.

### 5. Less actions, routes and JavaScript code

Let's analyze uploading images in a Rails app. You probably need following actions:

1. action to display form (e.g. `new`)
2. action for form processing which passes all jobs related to the image (cropping, creating different sizes, uploading to S3) to a *background task* (e.g. `create`)
3. action to which user is redirected after submitting form (e.g. `processing`)
4. action which returns results of background task (e.g. `results`). It is requested via AJAX call.

When you use Loco, you don't need 4th action, bacause you can just `emit` signal from background job directly to your JavaScript objects. So you don't need also route and JavaScript code that is responsible for polling for results. Just imagine how many features like that, your Rails apps have got. And how many lines of code you can get rid of.

### 6. Offline ready

Loco doesn't force you to structure your web app in a particular way. It's up to you whether you use Loco only on a few pages, split an app on a few panels (with different JS *manifest* files) and use Loco only on some or just make a single-page app. It's also a very good choice for a [shell architecture](https://developers.google.com/web/updates/2015/11/app-shell?hl=en). You can then use [Service Workers](http://www.html5rocks.com/en/tutorials/service-worker/introduction/) for offline caching and performance wins, in the form of instant loading for repeat visits. You can build a [Progressive Web App](https://developers.google.com/web/fundamentals/getting-started/your-first-progressive-web-app/?hl=en#what-is-a-progressive-web-app) that way.

### 7. Client-side form validation for free

If you define validations in JavaScript model and use instance of `App.UI.Form` class for form handling, then you'll get form validation, instantly. By the way, front-end validations are very similiar to the back-end ones. You can define them nearly by *copy-paste*.

# 🎪 Demo (ver. 1.0)

[![Loco: demo](http://img.youtube.com/vi/05iJNyIKZZU/0.jpg)](http://www.youtube.com/watch?v=05iJNyIKZZU)

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
