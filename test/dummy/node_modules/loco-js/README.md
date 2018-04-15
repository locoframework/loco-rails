![logo](https://raw.githubusercontent.com/artofcodelabs/artofcodelabs.github.io/master/assets/ext/loco_logo_trans_sqr-300px.png)

# 🧐 What is Loco-JS?

**Loco-JS** is a front-end framework similar to recently released [Stimulus](https://stimulusjs.org) in a fact that it doesn't want to take over your entire front-end.  
The difference is that **Loco-JS** was originally designed in 2016 and it works in more generic fashion. **Loco-JS** teams up well with tools like [React](https://reactjs.org) or [Vue](https://reactjs.org) for crafting a view layer.

Architecturally - Loco-JS is a front-end part of [**Loco-Rails**](http://github.com/locoframework/loco-rails), which can be used separately (with limited functionality).

And **Loco-Rails** is a back-end part of the whole [**Loco**](http://github.com/locoframework) framework and it requires **Loco-JS** to work.

**Loco-Rails** is just a concept that simplifies communication between front-end and back-end code. You can implement it in other languages or frameworks as well.  
I am a Rails programmer that's why I created **Loco** for **Rails**.

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

* by providing logical structure for a JavaScript code (along with base classes for models, controllers and views). You exactly know where to start, when looking for a JavaScript code that runs current page (**Loco-JS**)
* you have models that protect from sending invalid data to the API endpoints. They also facilitate fetching objects of a given type from the server ([**Loco-JS-Model**](https://github.com/locoframework/loco-js-model/))
* you can easily assign a model to a form what will enrich this form with fields' validation (**Loco-JS**)
* you can connect models with controllers and views on the front-end. And they will be notified about every change made to a corresponding model on the server side. This change will be emitted as a signal to the front-end code. And signal is just a fancy name for a JS object (**Loco**)
* it allows you to send messages over WebSockets in both directions with just a single line of code on each side (**Loco**)
* respects permissions (you can send messages only to specified, signed in on the server models _e.g. given admin or user_) (**Loco**)
* solves other common problems

# 🦕 Origins

**Loco** framework was created back in 2016. The main reason for it was a need to make my life easier as a full-stack developer.
I was using [Coffeescript](http://coffeescript.org) on the front-end back then and [Ruby on Rails](http://rubyonrails.org) on the back-end.

I still use **Rails** but my front-end toolbox has changed a lot. Now, I work with modern goodies such as **ES6**, [Webpack](https://webpack.js.org), [Babel](https://babeljs.io), [React](https://reactjs.org), [Redux](https://redux.js.org)... and **Loco-JS** obviously :)

**Loco-Rails** enriches Ruby on Rails. It's a functionality layer that works on top of Rails to simplify communication between front-end na back-end code. It is a concept that utilizes good parts of Rails to make this communication straightforward.

But **Loco-JS** can be used as a standalone library to structure a JavaScript code, for example.  
[**Loco-JS-Model**](https://github.com/locoframework/loco-js-model/) can be used without Rails as well and in cooperation with other modern tools such as React and Redux. You have to follow only a few rules of formatting JSON responses from the server.

# 🔬 Tech stack of Loco-JS

The Origins explain why some parts of **Loco-JS** are still written in CoffeeScript.	 It shouldn't worry you though unless you want to contribute.

What's more important is that all Loco-JS' modules are transpiled and bundled using modern tools such as **Babel** and **Webpack** accordingly. Loco-JS works well as a part of modern JavaScript ecosystem alongside libraries such as React.  
In the future, while adding features, all modules will be rewritten to Javascript.

# 🤝 Dependencies

🎊 Loco-JS has no external dependencies. 🎉

It depends only on Loco-JS-Model which is an internal part of Loco-JS but can be used separately as well (look at Loco-JS-Model [**dependencies**](https://github.com/locoframework/loco-js-model#-dependencies)❗️)  
Although, [class properties transform](https://babeljs.io/docs/plugins/transform-class-properties/) Babel plugin may be helpful to support static class properties, which are useful in defining models.  
Additionally, if you want to use Loco-JS with Loco-Rails and send or receive signals / messages over WebSocket connection, you have to pair up Loco-JS with [Action Cable](https://www.npmjs.com/package/actioncable).

# 📥 Installation

```bash
$ npm install --save loco-js
```

If you want to use Loco-JS by a script tag, without the module bundler, it's exposed as an `App` global variable.

# 🎬 Initialization

```javascript
import { Loco } from "loco-js";

const loco = new Loco({
  // set to your Turbolinks version if you use Loco-JS with Loco-Rails
  // and have enabled Turbolinks
  turbolinks: false,                   // false by default
  
  // the browser's app will start to receive signals / notifications from
  // the server either via WebSockets or AJAX polling (if WebSocket connection
  // can't be established). Loco-JS can even switch between WebSockets and AJAX
  // polling depending on the momentary availability. This works if you use
  // Loco-JS with Loco-Rails.
  notifications: {
    enable: true,                      // false by default
    //pollingTime: 3000,               // 3000 ms by default (for AJAX polling)
    
    // display upcoming notifications in browser's console e.g. for debugging
    //log: true,                       // false by default
    
    //ssl: false,                      // your current protocol by default
    
    // location must be the same as where you mounted Loco-Rails in routes.rb
    //location: "notification-center", // 'notification-center' by default
    
    // max number of notifications fetched at once via ajax pooling
    // must be the same as notifications_size defined in initializers/loco.rb
    // next batch of notifications will be fetched immediately after 
    // max size is reached
    //size: 100,                       // 100 by default
    
    // after specified time your current (namespace) controller instance method
    // disconnectedForTooLong will be called with the "time since disconnection"
    // passed as an argument
    //allowedDisconnectionTime: 10     // 10 by default [sec]
  },
  
  //locale: "en",                      // "en" by default
  
  // if provided - Loco-JS will be using absolute path 
  // instead of site-root-relative path in all xhr requests
  //protocolWithHost: "https://example.com",
  
  // this method is called at the end, after given controller's
  // method has been called. At this moment Loco's instance is initialized 
  // and you can use it to change some settings of the browser's app
  // e.g. polling interval -> Env.loco.getWire().setPollingTime(<time>);
  postInit: () => {}
});

loco.init();
```

# 👷🏻‍♂️ How does it work?

After document is loaded, Loco-JS' instance checks following `<body>`'s data attributes:

* data-namespace
* data-controller
* data-action

Then, based on their values, it initializes given controllers and calls given methods. Example:

```html
<body data-namespace="Main" data-controller="Pages" data-action="index">
</body>
```

Loco-JS will act like this (simplified version):

```javascript
import { Controllers } from "loco-js";

namespaceController = new Controllers.Main;
namespaceController.initialize();

controller = new Controllers.Main.Pages;
controller.initialize();
controller.index();
```

What's important is that Loco-JS looks not only for instance methods but static ones as well. If some controller is not defined, Loco-JS skips it. The same situation is with methods. You don't have to create controllers for every page that you have too. You can use Loco-JS only on desired ones. It does not want to take over your front-end. Augment with JavaScript only those pages that you want instead.

If namespace controller is not defined, Loco-JS will assume `Controllers.Pages` as a controller.

If you use Loco-JS along with Loco-Rails - after calling specified methods, Loco-JS will try to establish WebSocket connection with the server and will be waiting for signals / notifications.  
If WebSocket connection can't be established, Loco-JS will start periodically checking for new notifications via AJAX polling.

# 🔩 Merging classes

As you can see in the previous section, Loco-JS must have an access to all defined controllers to initialize them and to call given methods on them. Therefore, they have to be merged with `Controllers` object which Loco-JS exports.

```javascript
// javascripts/index.js (entry point)

import { Controllers } from "loco-js";

import Admin from "./controllers/admin"; // namespace controller
import User from "./controllers/user";   // namespace controller

Object.assign(Controllers, {
  Admin,
  User
});
```

```javascript
// javascripts/controllers/admin.js (namespace controller)

import { Controllers } from "loco-js";

import Coupons from "./admin/coupons"; // Coupons controller
import Plans from "./admin/plans";     // Plans controller 

class Admin extends Controllers.Base {}

Object.assign(Admin, {
  Coupons,
  Plans
});

export default Admin;
```

You don't have to define namespace controllers. You can merge controllers directly with exported `Controllers` object.

Remember to polyfill `Object.assign` or assign controllers using a different method.

Loco-JS exports also, among others, the `Models` object. Remember to do the same with all defined models - merge them with this object.

# 🏛 Structure

Loco-JS exports following structure:

```javascript
export {
  Channels,    // object                 - since ver. 1.3
  Controllers, // object
  Deps,        // object
  Env,         // object
  Helpers,     // object
  I18n,        // object
  Line,        // function (class)       - since ver. 1.3
  Loco,        // function (class)
  Mix,         // function (mixin class)
  Mixins,      // object
  Models,      // object
  Presenters,  // object
  Services,    // object
  UI,          // object
  Utils,       // object
  Validators,  // object
  Views,       // object
  Wire         // function (class)
};
```

Brief explanation of each element:

* **Channels** - the namespace where `ActionCable`'s subscriptions are created
* **Controllers** - the object that you have to merge all custom controllers with. It contains `Base` class for custom controllers
* **Deps** - this is an abbreviation of "dependencies". This object has 2 properties:
    * **cable** - if you want to send and receive signals / messages through WebSockets, assign consumer to this property by invoking `ActionCable.createConsumer();`
    * **NotificationCenter** - you have to assign a custom class to this property that is going to receive notifications sent via WebSockets
* **Env** - this object holds environmental informations. Its properties:
    * **action** - the value of the `data-action` attribute of `<body>`. This is also the name of the method that is called on the current controller
    * **controller** - the instance of the current controller
    * **namespaceController** - the instance of the current namespace controller
    * **loco** - the instance of `Loco` (see _Initialization_ section). Its most important instance methods are:
        * `getWire` - returns the current instance of `Wire`
        * `setLocale` / `getLocale` - allows to set / get current locale
    
        Look at [source code](https://github.com/locoframework/loco-js/blob/master/src/base/loco.coffee) for all.
* **Helpers** - the namespace where helpers are defined. Helpers are classes facilitating things like transforming text, converting numbers to currencies etc. Members:
    * **Text** - has method(s) that returns *text* transformed into HTML by using simple formatting rules
* **I18n** - the object that holds localizations. Localizations are objects as well
* **Line** - the class responsible for sending and receiving messages over WebSocket connection
* **Loco** - this class rules everything ;)
* **Mix** - the factory function that generates a `Mixed` superclass (used for implementing mixins)
* **Mixins** - the namespace where mixins are defined
* **Models** - the object which all custom models should be merged with. It contains `Base` class for custom models
* **Presenters** - the empty object that you can merge your custom presenters with. Presenters can be used to hold functions used to present models or their attributes.  
_Deprecated! It will be removed in the future. Store presenters on your own. This object doesn't have to be exported._ 
* **Services** - the namespace where service classes are defined. Members:
    * **Date** - its instance methods are useful for converting `Date` to a string
* **UI** - the namespace where classes that interact with the HTML are defined. Members:
    * **Form** - the class responsible for dealing with forms
* **Utils** - the namespace in which the classes containing the utility methods for the given data type are defined. Members: `Array`, `Collection`, `Dom`, `Object`, `String`
* **Validators** - the namespace where validators are defined and where custom validators should also be merged
* **Views** - the namespace where `Base` class for custom Views is defined
* **Wire** - the class responsible for fetching signals / notifications 

# 📡 Models

The model layer has been extracted to a separate [repository](https://github.com/locoframework/loco-js-model) and it can be used standalone as well. If you want to look at how to integrate [React](https://reactjs.org), [Redux](https://redux.js.org) and **Loco-JS-Model**, 🎁[**this repository**](https://github.com/artofcodelabs/front-end-boilerplate)🎁 may be a good starting point. 

## Nesting models 🏺

If you want to have two models with the same name or maybe you want to reflect a server architecture, you can even nest models. But only one-level nesting is allowed.

```javascript
// models/Coupon/Unit.js

import { Models } from "loco-js";

class Unit extends Models.Base {
  static identity = "Coupon.Unit";

  static remoteName = "Coupon::Unit"; // the name of the corresponding model
                                      // on the server side (Ruby syntax)

  static resources = {
    // ...
  };

  static attributes = {
    // ...
  };
}

export default Unit;
```

Remember to merge all defined models with the exported `Models` object:

```javascript
// models/index.js

import { Models } from "loco-js";

import Coupon from "./Coupon";
import Unit from "./Coupon/Unit";
import Admin from "./Admin";

Object.assign(Coupon, {
  Unit
});

Object.assign(Models, {
  Admin,
  Coupon
});
```

Loco-JS will be able to find the correct model in this situation if you emit a signal for the corresponding model on the server side.

# 🕹 Controllers

Like it's already been said - given method of given controller is called automatically based on HTML `<body>`'s attributes. 

Exemplary controller:

```javascript
// controllers/admin/coupons.js

import { Controllers } from "loco-js";

import New from "views/admin/coupons/new";
import List from "views/admin/coupons/list";

class Coupons extends Controllers.Base {
  static identity = "Coupons"; // persist the name of the class because
                               // it is going to be minified in production
                               // and knowing the name of the current controller
                               // can be useful (see the section about Line)
  
  // Loco-JS supports static and instance methods
  static index() {
    new List().render();
  }

  new() {
    const view = new New({ planId: this.params.id });
    this.setView("new", view); // assigning the instance of currently rendered
                               // view to the controller's property gives 
                               // a possibility to call other methods on it
                               // in the next life cycle
                               // (see the section about Line)
    view.render();
  }
}

export default Coupons;
```

To see all convenient properties and methods of the base class, other than `params` presented above, look at the [source code](https://github.com/locoframework/loco-js/blob/master/src/controllers/base.coffee).

Remember to merge all custom controllers with the `Controllers` object exported by Loco-JS (see the _Merging classes_ section). Optionally, you can use the namespace controller to set the default scope for models (`setResource` / `setScope`) methods.

# 🗺 Views

View is a layer where you should interact with the DOM to keep separation of concerns.  
[Base class](https://github.com/locoframework/loco-js/blob/master/src/views/base.coffee) delivers only a few methods, so it does not force you how to do so.  
The good practice is to always call `render` method on a view and treat it as a starting point.  
You can even render **React** components inside of view.

```javascript
// views/admin/coupons/new.js

import { Views } from "loco-js";
import React from "react";
import { render as renderElement } from "react-dom";

import CouponForm from "components/admin/CouponForm";
import Coupon from "models/Coupon";

class New extends Views.Base {
  constructor(opts) {
    super(opts);
    this.planId = opts.planId;
  }

  render() {
    this.renderCouponForm();
  }

  renderCouponForm() {
    const coupon = new Coupon({ resource: "admin", planId: this.planId });
    renderElement(
      <CouponForm coupon={coupon} />,
      document.getElementById("coupon-form")
    );
  }
}

export default New;
```

# 🔌 Connectivity

`Connectivity` is a mixin that is included in the `Base` classes of `Views` and `Controllers`. It allows you to send signals / notifications to all instances of controllers and views that are connected with given model classes or specific model instances. Example:

```javascript
// views/admin/coupons/list.js

import { Views } from "loco-js";

import Coupon from "models/Coupon";

class List extends Views.Base {
  constructor(opts) {
    super(opts);
  }

  async render() {
    this.connectWith([Coupon]); // every time back-end emits signal for 
                                // any coupon, receivedSignal method is called.
                                // An array of more than 1 model class can
                                // be passed as an argument. It is even possible
                                // to mix model classes and instances in this
                                // array
    const coupons = await Coupon.get("all", { resource: "admin" });
    this.connectWith(coupons.slice(-1), {  // method lastCouponReceivedSignal
      receiver: "lastCouponReceivedSignal" // is called only if a signal is
    });                                    // emitted by the back-end for
                                           // a specific Coupon instance 
                                           // that is the last element in 
                                           // "coupons" array at this moment
  }

  receivedSignal(signal, data) {
  }

  lastCouponReceivedSignal(signal, data) {
  }
}

export default List;
```

So if you use Loco-Rails on the back-end and emit a signal for the first coupon in the database, like this:

```ruby
# you can do it anywhere, in rails console for example
include Loco::Emitter
emit Coupon.first, :updated, { data: { foo: 'bar' } }
```

On the front-end side:

1. Loco-JS will receive a signal in the following format `["Coupon", 1, "updated", {foo: "bar", id: 1}]`
2. `receivedSignal` method will be called for every instance of the `List` class above (there is only one usually) with `"Coupon updated"` and `{foo: "bar", id: 1}` as the arguments 

If you, on the other hand, emit signal for the last coupon in the database `emit Coupon.last, :updated, { data: { foo: 'bar' } }`

On the front-end side:

1. Loco-JS will receive a signal `["Coupon", 27, "updated", {foo: "bar", id: 27}]`
2. `lastCouponReceivedSignal` method will be called with `updated` and `{foo: "bar", id: 27}` as arguments
3. `receivedSignal` method will be called with `Coupon updated` and `{foo: "bar", id: 27}` as arguments

# 🚠 Wire

Instance of this class works internally and is responsible for fetching notifications.  
The constructor takes an object whose many properties have been described in the *Initialization* section (look at the `notifications` property).

💥 In normal conditions, Wire checks and fetches notifications via AJAX polling. But if you have an established WebSocket connection _(see Line section)_, it will stop polling and will be waiting for informations, transmitted through WebSockets, about new, emitted by the back-end signals (to fetch them).  
In case of losing the WebSocket connection, it can automatically switch to AJAX polling.

[All accessor methods](https://github.com/locoframework/loco-js/blob/master/src/base/wire.coffee) that may be useful are rather straightforward and self-explanatory. The one that requires a bit of explanation is `setToken`.

* `setToken(token)` - when token is set, it is automatically appended to the requests that fetch notifications. So it allows you to fetch notifications assigned to a given token. It is useful, when you want to emit a signal / notification, on the back-end, to a user that is not authenticated in the system _(e.g. you want to notify a user that he has confirmed his email address successfully via clicking on a link and is now able to sign in)_

```javascript
import { Env } from "loco-js";
const wire = Env.loco.getWire(); // this is how to grab a working instance
                                 // of Wire during runtime and after
                                 // initialization (see Initialization section)
wire.setToken("foobarbaz");
```

On the back-end, you can now emit a signal to _"this token"_. And only _this_ user will receive the following signal.

```ruby
include Loco::Emitter
emit Coupon.last, :updated, { data: { foo: 'bar' }, for: 'foobarbaz' }
```

# 〰 Line

Instance of this class works internally and is responsible for sending and receiving messages over WebSocket connection.

These messages are not what we call signals / notifications. Signals / notifications must be associated with instances of models on the back-end while messages sent via `Line` don't have this requirement and are directed directly to recipients.

It is not required to use Line when using Loco-JS. It works currently only if you use Loco-Rails on the back-end and it requires [Action Cable](https://www.npmjs.com/package/actioncable) as a front-end dependency.

Loco-JS automatically creates an instance of `Line` and it subscribes to `Loco::NotificationCenterChannel` if it discovers `ActionCable`'s consumer under `Deps.cable` exported by Loco-JS.

## Configuration 🛠

```javascript
import { Deps } from "loco-js";
import ActionCable from "actioncable";

// you can use one global NotificationCenter or per "panel"
import NotificationCenter from "services/admin/NotificationCenter";

Deps.cable = ActionCable.createConsumer();
Deps.NotificationCenter = NotificationCenter;
```

## Sending messages 🚚

You can send messages over WebSocket connection after initializing Loco-JS (see _Initialization_ section).

```javascript
import { Env } from "loco-js";

const line = Env.loco.getLine();
line.send({ foo: "bar" });

// or using shortcut
Env.loco.emit({ baz: "buz"});
```

To see how to receive messages on the back-end, look at the [Loco-Rails documentation](https://github.com/locoframework/loco-rails#notification-center).

## Receiving messages 📩

Every time the back-end emits a signal to the front-end like this:

```ruby
include Loco::Emitter
# emit_to method emits message over WebSocket connection 
# to all signed in admins (in this example)
emit_to Admin.all, type: 'COUPON_CREATED', id: @coupon.id
```

`receivedSignal` static or instance method is called on `Deps.NotificationCenter` class.

```javascript
// services/admin/NotificationCenter.js

import { Env } from "loco-js";

class NotificationCenter {
  static receivedSignal(data) {
    switch (data.type) {
      case "COUPON_CREATED":
        this.couponCreated(data.id);
        break;
      default:
    }
  }

  static couponCreated(couponId) {
    // break if current controller is not Coupons
    if (Env.controller.constructor.identity !== "Coupons") return;
    
    // break if current action is not "new"
    if (Env.action !== "new") return;
    
    // call couponCreated method on the view - assigned to the current
    // controller as "new" by using setView method inherited 
    // from the Controllers.Base class
    Env.controller.getView("new").couponCreated(couponId);
  }
}

export default NotificationCenter;
```

# 📝 UI.Form

This class is useful when you want to allow users of you app to modify model's attributes. In other words, it connects a model instance with a form.  
`UI.Form` converts attributes of model's instance to the values of the corresponding form elements. It gives you a front-end validation without an extra effort and it turns standard static form into dynamic, submitted asynchronously one.

In this section I will be using exemplary model from [Loco-JS-Model README](https://github.com/locoframework/loco-js-model).

The following code presents a view with an example of initializing and using the `UI.Form`.

```javascript
// views/admin/coupons/new.js

import { UI, Views } from "loco-js";

import Coupon from "models/Coupon";

class New extends Views.Base {
  static initCoupon(planId) {
    return new Coupon({
      resource: "admin",
      planId,
      amountOff: 0.0,
      percentOff: 0,
      duration: "once"
    });
  }

  constructor(opts) {
    super(opts);
    this.coupon = this.constructor.initCoupon(opts.planId);
  }
  
  render() {
    const form = new UI.Form({
      for: this.coupon, // (optional) an instance of a model that is connected 
                        // with the form
      id: "coupon-form", // (optional) ID attribute of the HTML <form> element.
                         // If not passed - it will be resolved, based on
                         // whether model has ID, to: 
                         // * "edit_${lowercased model's identity prop}_${model's ID}"
                         // * "new_${lowercased model's identity prop}"
      initObj: false, // (optional) whether to initialize passed object based
                      // on values of corresponding form's elements.
                      // False by default (it has its initial attribute values)
      delegator: this, // (optional) an object to which all the callbacks 
                       // are delegated to
      callbackActive: "callbackActive", // (optional) the name of the function
                                        // that will be called after sending the request
      callbackSuccess: "callbackSuccess", // (optional) the name of the function that
                                          // will be called on success 
      callbackFailure: "callbackFailure" // (optional) the name of the function that
                                         // will be called if an object
                                         // is invalid on the front-end
                                         // or back-end side (400 HTTP status code)
    });
    
    form.render();
  }

  callbackActive() {
    console.log("Coupon is creating on the server...");
  }
    
  callbackSuccess(data) {
    console.log("Coupon has been created.");
  }
    
  callbackFailure() {
    console.log("Creation failed or front-end validations didn't pass.");
  }
}
```

From the HTML perspective - the following example shows how a form should be structured.  
What you should pay attention to is that all tags related to given attribute, should be wrapped by a tag with a proper **data-attr** attribute. The value of this attribute should match the **remote name** of given attribute (the name of the corresponding attribute on the server side, returned by an API).

Look at how errors are expressed. The tag is irrelevant, only **errors** class and **data-for** HTML attribute are important.

```html
<form id="coupon-form">
  <p data-attr="stripe_id">
    <label>Stripe ID</label><br>
    <input type="text" />
    <span class="errors" data-for="stripe_id"></span>
  </p>

  <p data-attr="amount_off">
    <input type="radio" name="amount_off" value="0" />
    <label>$0 off</label>

    <input type="radio" name="amount_off" value="20" />
    <label>$20 off</label>

    <input type="radio" name="amount_off" value="50" />
    <label>$50 off</label>

    <span class="errors" data-for="amount_off"></span>
  </p>

  <p data-attr="percent_off">
    <input type="hidden" name="percent_off" value="0" />

    <input type="checkbox" name="percent_off" value="50" />
    <label>50% off</label>

    <span class="errors" data-for="percent_off"></span>
  </p>

  <p data-attr="duration">
    <label>Duration</label><br>
    <select>
      <option value="forever">Forever</option>
      <option value="once">Once</option>
      <option value="repeating">Repeating</option>
    </select>
  </p>

  <p data-attr="duration_in_months">
    <label>Duration in months</label><br>
    <input type="text" />
    <span class="errors" data-for="duration_in_months"></span>
  </p>

  <p>
    <input type="submit" value="Submit" />
    <span class="errors" data-for="base"></span>
  </p>
</form>
```

Remember that when you submitting a form, **all model attributes** are sent to the server and not only those available to modify via the form fields.  
Model's attribute can be an object as well - for example, if you want to send a nested resources.

If model's ID is `null`, the instance is considered as new, not persisted on the server, so after submitting a form, Loco-JS will send the following XHR request:

```bash
Started POST "/admin/plans/7/coupons"
Parameters: {"coupon"=>{"stripe_id"=>"my-project-test", "percent_off"=>50, "amount_off"=>"0", "duration"=>"repeating", "duration_in_months"=>6, "max_redemptions"=>nil, "redeem_by"=>nil}, "plan_id"=>"7"}
```

On the other hand, if model instance has not null ID, Loco-JS sends the following XHR request to the server.

```bash  
Started PUT "/admin/plans/9/coupons/100"
Parameters: {"coupon"=>{"stripe_id"=>"my-project-test", "percent_off"=>0, "amount_off"=>"50", "duration"=>"once", "duration_in_months"=>nil, "max_redemptions"=>nil, "redeem_by"=>nil}, "plan_id"=>"9", "id"=>"100"}
```

The success response from the server should be in the JSON format with the following structure:

```javascript
{
  "success": true,
  "status": 200,
  "data": {      // (optional) this object that will be passed to 
    "id": 123,   // callbackSuccess if this function is defined
    "foo": "bar"
  },
  "flash": {                              // (optional) UI.Form changes the value
    "success": "Coupon has been created!" // of submit button depending on the current
  },                                      // state of the form and this key represents
                                          // the success state (a record has been saved)
  "access_token": "123qweasd" // (optional) when access_token is returned you can then
                              // emit on the server a signal assigned to that token
}
```

The example of the failure response:

```javascript
{
  "success": false,
  "status": 400,
  "errors": {
    "stripe_id": ["has already been taken"],
    "base": ["something wrong with the whole object"]
  }
}
```

# 🇵🇱 i18n

Loco-JS supports internationalization. Following example shows how to setup a different default language.

First, create a translation of the [base English file](https://github.com/locoframework/loco-js/blob/master/src/locales/en.coffee).

```javascript
// locales/pl.js

const pl = {
  // ...
  errors: {
    messages: {
      blank: "nie może być puste",
      inclusion: "nie jest na liście dopuszczalnych wartości",
      invalid: "jest nieprawidłowe",
      // ...
    }
  }
};

export default pl;
```

Loco-JS must have all translations assigned to `I18n` object.

```javascript
import { I18n, Loco } from "loco-js";

import pl from "locales/pl";

// remember to polyfill Object.assign or assign it in a different way
Object.assign(I18n, {
  pl
});

const loco = new Loco({
  // ...
  locale: "pl"
});

loco.init();
```

# 👩🏽‍🔬 Tests

```bash
npm run test
```

# 📈 Changelog

## Major releases 🎙

### 3.2

* loco-js-model ver. 0.3

### 3.1

* Static methods in controllers are also called

### 3.0

* Relying on `App` global variable has been removed
* Static `receivedSignal` is supported

### 2.1

* No need to assign to the `App` global variable

### 2.0

* Architectural changes (Webpack, ES6 modules etc.)

### 1.5

* Loco-JS dropped the dependency on jQuery. So it has no external dependencies officially 🎉

### 1.3

* Line

🔥 Only version 3 is under support and development.

Informations about all releases are published on [Twitter](https://twitter.com/artofcode_co)

# 📜 License

Loco-JS is released under the [MIT License](https://opensource.org/licenses/MIT).

# 👨‍🏭 Author

Zbigniew Humeniuk from [Art of Code](http://artofcode.co)
