# Welcome to Loco-Rails

> Rails is cool. But modern web needs Loco-motive.

Loco is.. for a lack of better word - a framework that works on top of [Rails](http://rubyonrails.org). It consists of 2 parts: front-end and back-end. I will be calling them **Loco-JS** and **Loco-Rails**, respectively, in the following sections of this README. So let's describe them shortly and their main responsibilities.

**Loco-JS** (front-end part) is a MVC+\* framework that provides structure for javascript assets. It supplies base classes for models, controllers and views. It's main responsibility it to call given controller's method based on Rails controller's method that handle current request. So it allows you to easily find Javascript logic that runs current page. 

Second the most important function is to periodically check for notifications. It is done under the hood and via ajax polling currently. Once the notification is received - object related to this notification and all connected objects (e.g. views, controllers) are notified. By *notified* - I mean that a given method is called (_receivedSignal_ by default).

```coffeescript
class App.Views.User.Articles.Form extends App.Views.Base
  constructor: (opts = {}) -> 
  	super opts
  	@article = null

  render: (@article) -> 
    this.connectWith @article  # this method is pure magic ;)
    this._renderArticle()

  receivedSignal: (signal, data) ->  # this method is auto called 
    switch signal
      when "updated"
        @article.reload().then => this._displayChanges @article.changes()
```

Loco-JS has build-in support for i18n. It is maintained in separate [repository](http://github.com/aoc-co/loco-js).

**Loco-Rails** (back-end part) is a Rails Engine. It allows you to simply send notifications, from any part of a system, directy to related JavaScript object and all connected objects.

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

So only one line is enough (**emit** method), in the code above, to magically send notification to all connected JavaScript objects in the browser. What's more - only user...

\* MVC+ - don't restrict yourself to only 3 layers. Good software is layered software. So Loco provides other layers out of the box also such as: templates, validators, services, helpers. Create your own if you need.

## Doubts

### Argument: ajax polling is oldschool. "Live" functionality should be accomplished through WebSockets. 

Answer: ...

### Argument: front-end part is developed in CoffeeScript. It should be in ES6.

Answer: That's true. But you know what - it's is developed in CoffeScript, then compiled to JavaScript and than ...

Parafrasing Giorgio Moroder from Daft Punk's track titled "Giorgio by Moroder":

> **Once you free your mind about programming languages and technology being correct - you can do whatever you want.**

## Main features

In terms of the whole system, not separate front-end and back-end parts (front-end part can run separatelly with limited functionality):  

### 1) Privides structure for Javascript assets

...

### 2) Big brother and little brother

Big brother

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
Little brother

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

### 3) Aktualny stan wszędzie

|  Browser A | Browser B |
|---|---|
| a | b |
| c | d |
| e | f |

### 4) Dashboard problem

### 5) Less actions and routes

### 6) Offline ready / progressive web app

## Requirements

...

### Ruby version

Specified in .ruby-version file

## Architecture

image here

### Garbage collecting

## Dependencies

### Back-end part

Loco works with Rails 4.2 onwards. You can add it to your Gemfile with:

```ruby
gem loco-rails
```

## Getting Started

1) Install Loco at the command prompt if you haven't yet:

```console
$ gem install loco-rails
```

2) At the command prompt, 

```console
$ rails generate loco:install
```

## Usage

```console
$ rails generate loco:controller
```

```console
$ rails generate loco:model
```

```console
$ rails rake generate loco:view
```

## Development

### How to run the test suite

```console
$ rake
```

## History

...

## Examples

...

## License
Ruby on Rails is released under the [MIT License](https://opensource.org/licenses/MIT).