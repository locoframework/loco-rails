# Welcome to Loco-Rails

> Rails is cool. But modern web needs Loco-motive.

**Loco** is.. for a lack of better word - a framework that works on top of [Rails](http://rubyonrails.org). It consists of 2 parts: front-end and back-end. I will be calling them **Loco-JS** and **Loco-Rails**, respectively. Both parts cooperate with each other. Let's describe them shortly and their main responsibilities.

## Loco-JS

**Loco-JS** (front-end part) is a *MVC+\** framework that provides structure for JavaScript assets. It supplies base classes for models, controllers and views. It's main function is to call given method of specified JS controller, based on Rails controller's method that handles current request. So it allows you to easily find Javascript logic that runs current page. 

Second, the most important function is to periodically check for notifications. It is done internally via ajax polling (currently). Once the notification is received - object related to this notification and all connected objects (e.g. views, controllers) are notified. By *notified*, I mean that a given method is called (`receivedSignal` by default).

Following example presents a view class. It's instance is connected with an instance of a certain model. It's done via calling `connectWith` method. Of course `render` method has to be called first. Then, if notification related to this model's instance is received - `receivedSignal` method is called automatically.

```coffeescript
class App.Views.User.Articles.Form extends App.Views.Base
  constructor: (opts = {}) -> 
    super opts
    @article = null

  render: (@article) -> 
    this.connectWith @article  # this method is pure magic ;)
    this._renderArticle()

  receivedSignal: (signal, data) -> 
    switch signal
      when "updated"
        @article.reload().then => this._displayChanges @article.changes()
```

Loco-JS has build-in support for I18n and is maintained in separate [repository](http://github.com/locoframework/loco-js). There you can read about futher details.

\* *MVC+* - don't restrict yourself to only 3 layers. Good software is layered software. So, Loco-JS provides other layers also, such as: templates, validators, services, helpers. Create your own if you need.

## Loco-Rails

**Loco-Rails** (back-end part) is a Rails Engine. It allows you to simply send notifications from any part of a system, directy to associated JavaScript object and all connected objects.

Following example presents a simple ActiveJob class that can `emit` *notifications / signals* directy to *associated* JavaScript objects. By *associated objects*, I mean - first and foremost - the JavaScript equivalent of given ActiveRecord object. It's an instance of a class that inherits from `App.Models.Base` and has the same name as given *ActiveRecord* class (in the most basic but recommended situation). I like to call them: **big brother and little brother** (better described in a section below). Also, all instances of JavaScript controllers and views, that have called `connectWith` method, will automatically receive emitted *signal / notification* for a given instance of ActiveRecord model.

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

So, only one line of code is enough (`emit` method) to *magically* send notifications to all connected JavaScript objects in the browser. What's more - only author of this article will receive notification. But, you can also pass an array of objects as receiverts of this signal. Those objects can be instances of ActiveRecord classes or the classes themselves (example below).

```ruby
emit article, :created, for: [Admin, article.user]
```

In the example above - both: author of the article and all signed in admins will receive signal. Is it available out of the box? Yes, almost.. Just put this method into the `ApplicationController`:

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

## Doubts

### Argument: AJAX polling is oldschool. "Live" functionality should be accomplished through WebSockets. 

**Answer:** Well, guess what - Loco works perfectly fine along with **ActionCable**. So if you need an instant functionality somewhere in your app, you can use ActionCable. But, in the other parts of an app, where ~1-3 second of latency doesn't matter, Loco works just fine. What's more, Loco provides structure for JS assets. So, you can structure your ActionCable code even better imo (see *examples* section below). It also allows you to do client-side rendering with ActionCable - easly. 

Personally, I find that sending over and over the same fat chunks of HTML (server-side rendering) is a waste of transfer (on cellular network especially) . Don't you think, that sending a template once and pure data only, subsequently (JSON API), is much better solution? For your wallet, for sure ;) Of course, Loco doesn't force anything. 

From here, we can go smoothly to another argument - when transfering another 30kB (jQuery) once and only, becomes pain.

### Argument: Loco-JS depends on jQuery, but we don't need jQuery, anymore.

**Answer:** Look at this [site](http://youmightnotneedjquery.com), for example. Almost always, you need to write more code to accomplish the same goal. And what we do, as developers, to write less code? We create private methods. We write another specialized classes. And we use 3rd party libraries. So, until no-jQuery approach will require to write longer code, I'll be with jQuery. But, I agree, that be dependent on sth is not good and *less dependencies* is better.

### Argument: Loco-JS is developed in CoffeeScript, but current standard is ES6.

**Answer:** Yeah, it's CoffeeScript. But you know what - it's developed in CoffeScript... Then, compiled to JavaScript... Then, concatenated to one file... And then, I inherit from those plain JavaScript objects (base *"classes"*) in my app written in CoffeeScript. How cool is that? You should be able to do sth similiar with ES6. But, I haven't tried that. 

I just *fcukin* hate parentheses and semicolons. And CoffeeScript is even better than Ruby in avoiding parentheses.

Parafrasing Giorgio Moroder from Daft Punk's track titled "Giorgio by Moroder":

> **Once you free your mind about programming languages and technology being correct - you can do whatever you want.**

## Main features

In terms of the whole system, the most important ones are the following: 

### 1. Provides structure for Javascript assets

I've said about that enough in the previous sections. Structure is just good and desirable.

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
And a little brother is right there:

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

So what this line actually do? Let's suppose that we have 104 records in the `articles` table on the server. This code makes 11 requests to `/articles.json`. Then, initializes 104 instances of `App.Models.Article`, based on JSON responses. Finally, it returns an object with 2 properties: **resources** and **count**. **resources** is an array of `App.Models.Article` instances and **count** is a total number of articles in a database. As you can see - Loco-JS' API is based on [Promises](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Promise).

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

So, you need to constantly refresh page to get an actual list of articles. Or you need to provide, as developer, some *"live"* functionality through AJAX or WebSockets. This requires a lot of unnecessary work/code for an every each element like that. It should be much easier. And by easier, I mean ~1 significant line of code on the server and front-end side. With Loco you can solve this problem like this:

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

In the *"standard"* approach - controller's action renders full page. If your dashboard has some dynamic elements, like charts for example - you need to hide raw data in **data attributes** or do some *spaghetti code*. It's  ingredients are Ruby and JavaScript. It's not recommended, but I think that everyone has prepared at least one dish like this ;-) Then, you need to ask front-end guys to process data and generate required dynamic views. They'll put JavaScript code in a place known only them, inside JavaScipt module or something... Then, they'll write (somewhere) code that fetches fresh data for every resource. You have to write API endpoints. 

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

![standard rendering](https://dl.dropboxusercontent.com/u/1493174/loco-rails/1.gif)

You can see that it affects UX significantly.

Another approach is to render static page or very light and fast page (with placeholders for example). Then, transfer logic responsible for fetching and presenting data to proper abstract JavaScript views. How you'll organize code is up to you. You can have main view with subviews or just few equivalent views. Simpler is better. How to notify front-end code about new events? Do you remember `emit` method? So just `emit` signal on server-side and receive it by all *connected* JavaScript objects. And you already know, where the JavaScript logic is located. Here is how rendering page this way is look like:

![async rendering](https://dl.dropboxusercontent.com/u/1493174/loco-rails/2.gif)

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

And the view (*comments/popular.jbuilder.json*) could look like this:

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

Loco-JS requires from you to return a JSON response with this structure - **resources** and **count** keys are mandatory.

### 5. Less actions, routes and JavaScript code

Let's analyze uploading images from Rails app. You probably need following actions:

1. action to display form (e.g. `new`)
2. action for form processing which passes all jobs related to the image (cropping, creating different sizes, uploading to S3) to a *background task* (e.g. `create`)
3. action to which user is redirected after submitting form (e.g. `processing`)
4. action which returns results of background task (e.g. `results`). It is requested via AJAX call.

When you use Loco, you don't need 4th action, bacause you can just `emit` signal from background job directly to your JavaScript objects. So you don't need also route and JavaScript code that is responsible for polling for results. Just imagine how many features like that, your Rails apps have got. And how many lines of code you can get rid of.

### 6. Offline ready

Loco doesn't force you to structure your web app in a particular way. It's up to you whether you use Loco only on a few pages, split an app on a few panels (with different JS *manifest* files) and use Loco only on some or just make a single-page app. It's also a very good choice for a [shell architecture](https://developers.google.com/web/updates/2015/11/app-shell?hl=en). You can then use [Service Workers](http://www.html5rocks.com/en/tutorials/service-worker/introduction/) for offline caching and performance wins, in the form of instant loading for repeat visits. You can build a [Progressive Web App](https://developers.google.com/web/fundamentals/getting-started/your-first-progressive-web-app/?hl=en#what-is-a-progressive-web-app) that way.

### 7. Client-side form validation for free

If you define validations in JavaScript model and use instance of `App.UI.Form` class for form handling, then you'll get form validation, instantly. By the way, front-end validations are very similiar to the back-end ones. You can define them nearly by *copy-paste*.

## Dependencies

### Strict dependencies

Dependencies that are required for Loco to work:

**Loco-JS**

* jQuery 2.2.4 or higher

**Loco-Rails**

* modern Ruby (tested on >= 2.3.0)
* Rails >= 4.2

### Soft dependencies

Recommended dependencies that facilitate development of web app and are not required for Loco to work:

**Loco-JS**

* [lie](https://github.com/calvinmetcalf/lie) - promise library implementing the Promises/A+ spec Version 1.1. Because Loco-JS is based on promises and promises are supported natively only in [some browsers](http://caniuse.com/#feat=promises)

**Loco-Rails**

* [eco](https://github.com/sstephenson/eco) - lets you embed CoffeeScript logic in your markup. Useful when using JST templates. Look at `test/dummy`'s front-end code for examples.

## Architecture

When you `emit` signal (~ notification), this signal is actually a record in the **loco_notifications** table in database. Client front-end apps constantly check whether there are new notifications for them. They do this by sending **synced_at** param which they get back with each response. One of the advantages of this solution is - when client lose connection with the server and restore it after some time - he will get all not received notifications. Unless you delete them before, of course. It leads to the next issue...

### Garbage collection

When you emit a lot of notifications, you obviously create a lot of records in the database. This way, your **loco_notifications** table may by very big soon. You need to get rid of old records, periodically. You may do this, like I present in the following code. It's quite a naive approach but it works for me for months.

```ruby
class GarbageCollectorJob < ActiveJob::Base
  queue_as :default

  after_perform do |job|
    GarbageCollectorJob.set(wait_until: 1.hour.from_now).perform_later
  end

  def perform
    Loco::Notification.where("created_at < ?", 1.hour.ago).
      find_in_batches do |batch|
        batch.each{ |notification| notification.destroy }
      end
  end
end
```

## Getting Started

Loco works with Rails 4.2 onwards. You can add it to your Gemfile with:

```ruby
gem 'loco-rails'
```

At the command prompt run:

```bash
$ bundle install
$ bin/rails generate loco:install
$ bin/rails db:migrate
```

Loco-JS is bundled inside Loco-Rails and named `loco-rails.js` Since it is a JavaScript library, I recommend to resolve JavaScript dependencies using native package managers. So I encourage you to install Loco-JS and all JavaScript libraries using Bower:

```bash
$ bower install loco-js --save
```

Then, you have to replace one line in your JavaScript manifest file:

```javascript
//= require loco-rails
```

to

```javascript
//= require loco-js
```

Look inside `test/dummy/` to see how Bower is configured.

## Usage

### Development

Along with Loco-Rails come generators, that speed up front-end development. Run *help* for more details.

```bash
$ bin/rails generate loco:controller
$ bin/rails generate loco:model
$ bin/rails generate loco:view
```

### How to run the test suite

```bash
$ bin/rake
```

### Emitting signals

1. include `Loco::Emitter` inside a class and then use `emit` instance method
2. initialize `Loco::Broadcaster` object and call `emit` method on it 

`Loco::Emitter` module uses `Loco::Broadcaster` object inside `emit` method.

#### Anatomy of Loco::Broadcaster

`emit` method of `Loco::Emitter` module and constructor of `Loco::Broadcaster` take the same arguments:

1. an object whose the notification concerns
2. a name of an event that occured (Symbol / String). Default values are:
	* **:created** - when created\_at == updated\_at
	* **:updated** - when updated\_at > created\_at
3. a hash with relevant keys:
	* **:for** - receiver of the signal. It can be a single object or an array of objects. Instances of models, their classes and strings are acceptable. If receiver is a class, then given signal is addressed to all instances of this class. If receiver is a string (token), then clients who have subscribed to this token on the front-end side, will receive notifications. They can do this by invoking this code: `App.Env.loco.getWire().setToken '<token>'`
	* **:data** - additional data that will be transmitted along with notification. This data are serialized to JSON in database.

Example:

```ruby
include Loco::Emitter

receivers = [article.user, Admin, 'a54e1ef01cb9']
data = {foo: 'bar'}

emit article, :confirmed, for: receivers, data: data
# is equivalent to
Loco::Broadcaster.new(article, :confirmed, for: receivers, data: data).emit
```

### Emitting signals for non-ActiveRecord objects

When dealing with non-ActiveRecord objects (e.g. uploaded files), you don't have to create unnecessary models on the back-end side to communicate something. Plain ruby classes are enough:

```ruby
class DirectMessage
  def id; 0 end
end

emit DirectMessage.new, :csv_processed, data: {foo: 'bar'}, for: event.user
```

```coffeescript
class App.Models.DirectMessage extends App.Models.Base
  @identity = 'DirectMessage'
  
class App.Controllers.User.Events extends App.Controllers.Base
  show: ->
    @view = new App.Views.User.Events.Show
    this.connectWith [App.Models.DirectMessage]
    
  receivedSignal: (signal, data) ->
    switch signal
      when 'DirectMessage csv_processed' then @view.renderResuls data
```

## Examples

* examine `test/dummy` app for real-life use cases of almost all Loco's features in various scenarios
* [Loco + ActionCable example app](http://github.com/locoframework/example-action-cable)

## License
Loco-Rails is released under the [MIT License](https://opensource.org/licenses/MIT).

## Author

Zbigniew Humeniuk