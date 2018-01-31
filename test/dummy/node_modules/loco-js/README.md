![logo](https://raw.githubusercontent.com/artofcodelabs/artofcodelabs.github.io/master/assets/ext/loco_logo_trans_sqr-300px.png)

# 🚧 This documentation is under construction. Come back soon! 🚧

# Welcome to Loco-JS

**Loco** is a framework that works on top of [Rails](http://rubyonrails.org). It consists of 2 parts:

* [**Loco-Rails**](http://github.com/locoframework/loco-rails) - a back-end part
* **Loco-JS** - a front-end part

Loco-JS can work separately with limited functionality and is maintained in this repository. Following sections contain more detailed description of its internals and API. Loco-JS' role in the **Loco** framework is described on the [Loco-Rails page](http://github.com/locoframework/loco-rails).

## Major releases

Informations about all releases are published on [Twitter](https://twitter.com/artofcode_co)

### 1.5

* Loco-JS dropped the dependency on jQuery. So it officially has no dependencies 🎉

## Dependencies

Loco-JS has no dependencies. But it's based on [Promises](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Promise) and promises are not supported natively in [IE](http://caniuse.com/#feat=promises). So, if you care, I recommend to use [lie](https://github.com/calvinmetcalf/lie).

## Getting started

Include [`dist/loco.js`](dist/loco.js) in your application’s JavaScript bundle.

### Installation using Ruby on Rails

Loco-JS is included inside the [`loco-rails`](https://github.com/locoframework/loco-rails) gem. To install:

1. Add `loco-rails` to your Gemfile: `gem 'loco-rails'`
2. Run `bundle install`.
3. Add `//= require loco-rails` to your JavaScript manifest file (usually at `app/assets/javascripts/application.js`).

### Installation using NPM

```bash
$ npm install --save loco-js
```

### Initalization

```coffeescript
loco = new App.Loco
  # set to your Turbolinks version if you have enabled Turbolinks
  turbolinks: 5                       # false by default

  # your browser's app will be checking for new notifications periodically via ajax polling
  notifications:
    enable: true                      # false by default
    #pollingTime: 3000                # 3000 ms by default

    # display upcoming notifications in browser's console e.g. for debugging
    #log: true                        # false by default

    #ssl: false                       # your current protocol by default

    # location must the same as where you mount Loco in routes.rb
    #location: 'notification-center'  # 'notification-center' by default

    # max number of notifications that is fetched at once via ajax pooling
    # must be the same as notifications_size defined in initializers/loco.rb
    # next batch of notifications will be fetched immediately after max size is reached
    #size: 100                        # 100 by default

    # after this time your current namespace controller / controller instance method
    # disconnectedForTooLong: will be called with the 'time since disconnection' passed as an argument
    #allowedDisconnectionTime: 10     # 10 by default [sec]
  #locale: 'en'                       # 'en' by default

  # if provided - loco will be using absolute path instead of site-root-relative path in all xhr requests
  #protocolWithHost: 'https://example.com'

  # this method is called at the end, after given controller methods has been called
  # at this time Loco's instance is initialized and you can use it to change behaviour of your browser app
  # e.g. polling interval -> App.Env.loco.getWire().setPollingTime <time>
  #postInit: ->

loco.init()
```

## Usage

After calling `init()` Loco-JS' instance checks following `<body>`'s data attributes:

* data-namespace
* data-controller
* data-action

Then, based on their values, it initializes given controller and calls given methods. Example:

```html
<body data-namespace="Main" data-controller="Pages" data-action="index">
</body>
```

Loco-JS will act like this:

```coffeescript
namespaceController = new App.Controllers.Main
namespaceController.initialize()

controller = new App.Controllers.Main.Pages
controller.initialize()
controller.index()
```

All methods will be called, if are defined. If namespace controller is not defined, Loco will assume `App.Controllers.Pages` as controller.

If you've enabled notifications, Loco will begin checking for them periodically.

## Structure

Type `App` in the browser's console and you'll get:

```javascript
Object {
  Channels: Object,                     // since ver. 1.3
  Controllers: Object,
  Env: Object,
  Helpers: Object,
  I18n: Object,
  IdentityMap: function IdentityMap(),
  Line: function Line(opts),            // since ver. 1.3
  Loco: function Loco(opts),
  Mix: function (),
  Mixins: Object,
  Models: Object,
  Presenters: Object,
  Services: Object,
  UI: Object,
  Utils: Object,
  Validators: Object,
  Views: Object,
  Wire: function Wire(opts),
  __proto__: Object
}
```

Let's describe each object / function briefly. I'll be using CoffeeScript nomenclature.

* **Channels** - a namespace where are defined `ActionCable`'s subscriptions
* **Controllers** - a namespace where you define controllers
* **Env** - an object that has following properties:
	* **action** - a name of current action (method called on an instance of current controller)
	* **controller** - an instance of current controller
	* **loco** - an instance of `App.Loco`. It's the most important instance methods are:
		* `getWire` - returns current instance of `App.Wire`
		* `setLocale` / `getLocale` - allows you to set / get current locale
	* **namespaceController** - an instance of current namespace controller
	* **scope** - current scope (used by models to determine URL of resources)
* **Helpers** - a namespace where you define helpers. Member classes:
	* **Text** - has method(s) that returns *text* transformed into HTML by using simple formatting rules
* **I18n** - an object that holds localizations. Localizations are objects too
* **IdentityMap** - a class that stores information about *connected* objects
* **Line** - a class that is responsible for sending and receiving messages over WebSocket connection
* **Loco** - this class rules everything ;)
* **Mix** - a factory function that generates a `Mixed` superclass (used for implementing mixins)
* **Mixins** - a namespace where mixins are defined
* **Models** - a namespace where you define models
* **Presenters** - an empty namespace where you define presenters
* **Services** - a namespace where you define services. Member classes:
	* **Date** - it's instance methods are useful for formatting `Date` as string
* **UI** - a namespace where UI components are defined. Member classes:
	* **Form** - a class responsible for dealing with forms
* **Utils** - a namespace where utility classes are defined. Members:
	* **Array** - utilities for arrays
	* **Collection** - utilities for collections (arrays and objects)
	* **String** - utilities for strings
* **Validators** - a namespace where validators are defined
* **Views** - a namespace where you define views
* **Wire** - a class that is responsible for fetching notifications

## Models

### Fetching a collection of resources (pagination)


```coffeescript
App.Models.Article.get('all', resource: 'main').then (resp) ->
# GET "/articles?page=1"
# GET "/articles?page=2"
# GET "/articles?page=3"
# ...

App.Models.Article.get('published', resource: 'admin', page: 2).then (resp) ->
# GET "/admin/articles/published?page=2"
```

Loco-JS supports nested resources. Only single nesting is allowed. Example:

```coffeescript
class App.Models.Article.Comment extends App.Models.Base
  @identity = "Article.Comment"
  @remoteName = "Comment"
  @resources =
    url: '/user/articles/:articleId/comments', paginate: {per: 10}

App.Models.Article.Comment.all(articleId: 321, page: 2).then (resp) ->
# GET "/user/articles/321/comments?page=2"
```

You can also pass additional parameters. Example:

```coffeescript
App.Models.Article.Comment.all({
  articleId: 21,
  page: 2,
  title: 'foo',
  content: 'bar'
}).then (resp) ->
# GET "/user/articles/21/comments?page=2&title=foo&content=bar"
```

### Fetching a single resource

Loco-JS provides `find` class method for fetching a single resource. The response from the server should be in a plain JSON format with remote names of attributes as keys. Examples:

```coffeescript
App.Models.Article.find(123).then (article) ->
# or
App.Models.Article.find(id: 123).then (article) ->
# GET "/user/articles/123"

App.Models.Article.Comment.find(id: 33, articleId: 123).then (comment) ->
# GET "/user/articles/123/comments/33"

# adding additional parameters
App.Models.Article.Comment.find({
  id: 33,
  articleId: 123,
  foo: 'bar',
  baz: 'buz'
}).then (comment) ->
# GET "/user/articles/123/comments/33?foo=bar&baz=buz"
```

### Sending requests

Each model has inherited from `App.Models.Base` methods for sending requests of given type to the server. All methods that send requests of the equivalent type are listed below:

* instance methods: `get` `post` `put` `delete`
* class methods: `@get` `@post` `@put` `@delete`

Examples:

```coffeescript
# usually you use class methods for fetching resources. It's just an example here:
# App.Models.Article.post('published', resource: 'admin', page: 2)
# POST "/admin/articles/published"
# Parameters: {"page"=>2}

App.Models.Article.find(id: 43).then (article) ->
  article.put "publish", foo: 'bar', buz: 1
# PUT "/user/articles/43/publish"
# Parameters: {"foo"=>"bar", "buz"=>"1", "id"=>"43"}
```

### Validation

If you have specified validations for attributes, you can use `isValid` / `isInvalid` methods to check whether an instance of a model is valid or not.

Example:

```coffeescript
article = new App.Models.Article title: 'f'
article.isValid()  # false
article.errors  # {title: ["is too short (minimum is 3 characters)"], content: ["can't be blank"]}
```

When you use `App.UI.Form` for handling forms, validation is done automatically and errors are shown if object is invalid.

Loco-JS implements almost all built-in [Rails](http://guides.rubyonrails.org/active_record_validations.html) validators, except *uniqueness*. And you can use them nearly identically. For more use cases and examples look at the source code (*/validators*), *Examples* section and specs.

### Dirty object

*Dirty object* is an ability of models' instances to express how values of attributes have been changed between 2 moments in time - when an object was initialized and their current value on the server. The most common use case is a reaction to the **update** signal, presented below. You can apply all changes (`applyChanges` method) and re-render the article. Or just present them to the user and apply manually selected ones - for example.

```coffeescript
receivedSignal: (signal, data) ->
  switch signal
    when 'updated'
      @article.reload().then =>
        @article.changes()  # {title: {is: 'bar', was: 'foo'}, content: {is: 'buz', was: 'baz'}}
        @article.applyChanges()
        this.renderArticle()
```

## Connectivity

`App.Mixins.Connectivity` is a mixin, which is included in `App.Controllers.Base` and `App.Views.Base` base classes. It has very important instance method `connectWith`. You will use this method probably always inside instance methods of controllers and views. `connectWith` accepts 2 arguments. The first one can be an object or an array. Allowed are instances of models and class names of models. Example:

```coffeescript
this.connectWith [App.Models.Article, App.Models.Article.Comment, user]
this.connectWith article, receiver: "_articleReceivedSignal"
```

The second argument is optional and should be an object with *receiver* property. It specifies which method will be called when notification / signal related to connected object / objects is received.

If you pass a class name (or names) as connected object then you will receive notifications / signals related to all instances of this class.

Check *Examples* section for real-life usage.

## Controllers

`App.Controllers.Base` base class is pretty straightforward. Just look at the source code for more details about implemented methods. More important things are:

* `params` property - an object with URL params
* `setScope` / `setResource` method - sets default scope for all models (which URL is used for fetching resources)

## Views

`App.Views.Base` base class is also straightforward and source code is self-explanatory. For more use cases check *Examples* section.

## App.UI.Form

This class is responsible for handling forms. It converts attributes of model's instance to the values of corresponding form elements. It's constructor accepts an object with following properties (all are optional):

* **id** *(String)* - HTML **id** attribute of the form. If you don't pass this property, it will be resolved based on *Ruby on Rails* naming convention.
* **for** *(Object)* - an instance of a model that is connected with the form
* **initObj** *(Boolean)* - whether to initialize passed object based on values of corresponding form's elements.
* **delegator** *(Object)* - an object to which the following methods are delegated to
* **callbackSuccess** *(String)*
* **callbackFailure** *(String)*
* **callbackActive** *(String)*

Following HTML code shows how a form should be structured. What is important - all tags related to given attribute, should be wrapped by a tag with **field** class and proper **data-attr** attribute. The value of this attribute should match the **remote name** of given attribute (name of the corresponding attribute on the server side). Look at how errors are expressed. The tag is irrelevant, only **errors** class and **data-for** HTML attribute are important.

Example:

```html
<form class="edit_article" id="edit_article_42" action="/user/articles/42"
  accept-charset="UTF-8" method="post">

  <input name="utf8" type="hidden" value="&#x2713;" />
  <input type="hidden" name="_method" value="patch" />
  <input type="hidden" name="authenticity_token" value="secret" />

  <div class="field" data-attr="title">
    <label for="article_title">Title</label><br>
    <input type="text" value="A few examples" name="article[title]" id="article_title" />
    <span class="errors" data-for="title"></span>
  </div>

  <div class="field" data-attr="text">
    <label for="article_text">Text</label><br>
    <textarea name="article[text]" id="article_text"></textarea>
    <span class="errors" data-for="text"></span>
  </div>

  <div>
    <input type="submit" name="commit" value="Update Article" />
    <span class="errors" data-for="base"></span>
  </div>
</form>
```

## App.Wire

Instance of this class works internally and is responsible for fetching notifications. Following code shows - how to get this instance during runtime:

```coffeescript
App.Env.loco.getWire()
```

The constructor takes an object whose many properties have been described in the *initialization* section, earlier. All methods are rather straightforward and self-explanatory, but you should pay attention to the `setToken` one. When `@token` is not null, it is automatically appended to the requests that are responsible for fetching notifications. So it allows to fetch notifications assigned to given token.

## App.Line (since ver. 1.3)

Instance of this class works internally and is responsible for sending and receiving messages over WebSocket connection. Loco-JS automatically creates instance of `App.Line` and subscribes to `Loco::NotificationCenterChannel` if discovers `ActionCable`'s consumer under `App.cable`. Following code shows - how to get this instance during runtime:

```coffeescript
App.Env.loco.getLine()
```

### Sending messages

```coffeescript
App.Env.loco.getLine().send({})

# or using shortcut:
App.Env.loco.emit({})
```

### Receiving messages

Loco-Rails delivers `loco:install` generator that creates following class at *JS-ASSETS-ROOT/services/notification_center.coffee*

```coffeescript
class App.Services.NotificationCenter
  receivedSignal: (data) ->
```

Every time a message is sent from the server, `receivedSignal` instance method is called.

## Development

### Development and testing

Look inside `gulpfile.js` for more details.

## Examples

* examine `test/dummy` app inside [Loco-Rails project](http://github.com/locoframework/loco-rails) for real-life use cases of almost all Loco's features in various scenarios

## License
Loco-JS is released under the [MIT License](https://opensource.org/licenses/MIT).

## Author

Zbigniew Humeniuk from [Art of Code](http://artofcode.co)
