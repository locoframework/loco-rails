![logo](https://raw.githubusercontent.com/artofcodelabs/artofcodelabs.github.io/master/assets/ext/loco_logo_trans_sqr-300px.png)

> A missing model layer for modern JavaScript

# 🧐 What is Loco-JS-Model?

It can be said that **Loco-JS-Model** is a model part of [**Loco-JS**](http://github.com/locoframework/loco-js), which __can be used separately__.  
**Loco-JS** is in turn a front-end part of [**Loco-Rails**](http://github.com/locoframework/loco-rails). It can be used separately as well (with limited functionality).  
And **Loco-Rails** is a back-end part of the whole [**Loco**](http://github.com/locoframework) framework and it requires **Loco-JS** to work.

**Loco-Rails** is just a concept that simplifies communication between front-end and back-end code. It can be implemented in other languages or frameworks as well.  
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

* by providing logical structure for a JavaScript code (along with base classes for models, controllers and views). You exactly know where to start, when looking for a JavaScript code that runs current page ([**Loco-JS**](https://github.com/locoframework/loco-js))
* you have models that protect from sending invalid data to the API endpoints. They also facilitate fetching objects of a given type from the server (**Loco-JS-Model**)
* you can easily assign a model to a form what will enrich this form with fields' validation ([**Loco-JS**](https://github.com/locoframework/loco-js))
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

# 🔬 Tech stack of Loco-JS-Model

The Origins explain why the major part of **Loco-JS-Model** is still written in CoffeeScript.	 It is just an extraction from Loco-JS for everyone who don't need all the features that Loco-JS provides. It shouldn't worry you though unless you want to contribute.

What's more important is that all Loco-JS-Model's modules are transpiled and bundled using modern tools such as **Babel** and **Webpack** accordingly. Loco-JS-Model works well as a part of modern JavaScript ecosystem alongside libraries such as React and Redux.  
In the future, while adding features, all modules will be rewritten to Javascript.

This 🎁[**example**](https://github.com/artofcodelabs/front-end-boilerplate)🎁 presents how to combine Loco-JS-Model with React and Redux _(+ other neat tools)_.  
This repo is also a good starting point when you want to start hack on multi-static-page app powered by React, Redux, React, React-Router, Webpack, Babel etc. and you look for something pre-configured and more straightforward than [Create React App](https://github.com/facebook/create-react-app) at the same time.

# 📡 Model Layer

I really liked [ActiveRecord](http://guides.rubyonrails.org/active_record_basics.html) throughout the years of using Rails. This layer stands between the business logic of your app and database itself and does a lot of useful things. One of many is providing validations of the objects to ensure that only valid data are saved into your database. It also provides several finder methods to perform certain queries on your database without writing raw SQL.

## But what does model mean when it comes to the app that works inside the browser? 🤔

Well, you have at least 2 ways to persist your data:

1. You can save them in the local storage
2. You can send them to the server using the API endpoint, where they will be stored in the database

So we can assume that validating the data before they reach destination will be useful in both cases. But when it comes to persistence, Loco-JS-Model gravitates towards communication with the server. It provides methods that facilitate both persisting data and fetching them from server.

It will be more obvious, when we look at the examples. But first we have to set things up.

# 📥 Installation

```bash
$ npm install --save loco-js-model
```

# 🤝 Dependencies

🎊 Loco-JS-Model has no dependencies. 🎉

Although, [class properties transform](https://babeljs.io/docs/plugins/transform-class-properties/) Babel plugin may be helpful to support static class properties, which are useful in defining models.

Loco-JS-Model uses Promises so remember to **polyfill** them❗️

# ⚙️ Configuration

```javascript
import { Config } from "loco-js-model";

// If provided - Loco will be using absolute path 
// instead of site-root-relative path in all XHR requests
Config.protocolWithHost = "http://localhost:3000";

Config.locale = "pl";   // "en" by default

// Models have static class property - "resources".
// You use it to specify named scopes (base URLs),
// where you can fetch objects of given type.
// You can setup default scope for all models,
// using this property.
Config.scope = "admin"; // null by default

```

# 🎮 Usage

## Anatomy of the model 💀

This is how an exemplary model can look like:

```javascript
// models/Coupon.js

import { Models } from "loco-js-model";

import { decimalize, nullIfNaN } from "helpers/number";

class Coupon extends Models.Base {
  // This property should have the name of the class.
  // Setting this property is required when you use full Loco framework
  // and send notifications from the server.
  // Because of minification, finding this class by name, 
  // is improssible in production env.
  // Loco relies on naming, so it has to be persisted.
  static identity = "Coupon";

  // It stores information about scopes in your app.
  // You can fetch the same type of resource from different API endpoints.
  // So you can define them using this property.
  static resources = {
    url: "/user/coupons",
    admin: {
      url: "/admin/plans/:planId/coupons",
      paginate: { per: 100, param: "current-page" }
    }
  };

  // This property stores information about model's attributes
  static attributes = {
    stripeId: {
      // Specify if different from what API returns
      remoteName: "stripe_id",
      // When assigning values from API endpoint,
      // Loco-JS-Model may convert them to certain types.
      // Available: Date, Integer, Float, Boolean, Number, String
      type: "String",
      // Available validators: Absence, Confirmation, Exclusion, 
      // Format, Inclusion, Length, Numericality, Presence, Size
      validations: {
        presence: true,
        format: {
          with: /^my-project-([0-9a-z-]+)$/
        }
      }
    },
    percentOff: {
      remoteName: "percent_off",
      type: "Integer",
      validations: {
        // you can run given validators conditionally
        presence: { if: o => o.amountOff == null },
        numericality: {
          greater_than_or_equal_to: 0,
          less_than_or_equal_to: 100
        }
      }
    },
    // This attribute should be of type decimal but it has no type.
    // It is because of I use this model with React 
    // and I change the value of this attribute,
    // every time user fills number in the input field.
    // So it can have incorrect decimal value (like "12." for example),
    // when user is in the middle of writting final value.
    // If I'd specify the type, Loco-JS-Model would make a convertion
    // to this type on every key press.
    // This would make it improssible to fill in the desired number.
    // If you don't use React, this "constant binding" or just you use
    // a different strategy, it's a good practice to always specify type.
    amountOff: {
      remoteName: "amount_off",
      validations: {
        presence: { if: o => o.percentOff == null },
        numericality: {
          greater_than_or_equal_to: 0
        }
      }
    },
    duration: {
      type: "String",
      validations: {
        presence: true,
        inclusion: {
          in: ["forever", "once", "repeating"]
        }
      }
    },
    durationInMonths: {
      remoteName: "duration_in_months",
      type: "Integer",
      validations: {
        numericality: {
          greater_than: 0,
          if: o => o.duration === "repeating"
        }
      }
    },
    maxRedemptions: {
      remoteName: "max_redemptions",
      type: "Integer",
      validations: {
        numericality: {
          greater_than: 0,
          if: o => o.maxRedemptions != null
        }
      }
    },
    redeemBy: {
      remoteName: "redeem_by",
      type: "Date"
    }
  };

  // Contains names of custom validation methods
  static validate = ["amountOrPercent", "futureRedeemBy"];
  
  // This method is called when you use full Loco framework
  // and emit signals from the server to the whole class of objects
  static receivedSignal(signal, data) {}

  constructor(data = {}) {
    super(data);
  }

  get amountOffNum() {
    return Number(this.amountOff);
  }
  
  // This method is called when you use full Loco framework
  // and emit signals from the server to this specific instance of model
  receivedSignal(signal, data) {}

  // Custom method that is called when user changes value of field 
  // in React component
  setAttribute(name, val) {
    // This Loco-JS-Model's method makes a convertion to given type,
    // when assigning value to attribute
    this.assignAttr(name, val);
    this.normalizeAttributes();
  }

  // private

  normalizeAttributes() {
    this.percentOff = nullIfNaN(this.percentOff);
    this.maxRedemptions = nullIfNaN(this.maxRedemptions);
    this.durationInMonths = nullIfNaN(this.durationInMonths);
    this.normalizeAmountOff();
  }

  normalizeAmountOff() {
    if (Number.isNaN(this.amountOffNum)) this.amountOff = null;
    if (!this.amountOff) return;
    this.amountOff = decimalize(this.amountOff);
  }

  amountOrPercent() {
    if (this.percentOff === 0 && this.amountOffNum === 0) {
      // This Loco-JS-Model's method allows you
      // to assign error message to given attribute
      this.addErrorMessage('can\'t be 0 if "Percent off" is 0', {
        for: "amountOff"
      });
      this.addErrorMessage('can\'t be 0 if "Amount off" is 0', {
        for: "percentOff"
      });
    } else if (this.percentOff !== 0 && this.amountOffNum !== 0) {
      this.addErrorMessage('should be 0 if "Percent off" is not 0', {
        for: "amountOff"
      });
      this.addErrorMessage('should be 0 if "Amount off" is not 0', {
        for: "percentOff"
      });
    }
  }

  futureRedeemBy() {
    if (this.redeemBy === null) return;
    if (this.redeemBy <= new Date()) {
      this.addErrorMessage("should be in the future", { for: "redeemBy" });
    }
  }
}

export default Coupon;
```

```javascript
// helpers/number.js

export const decimalize = val => {
  const integer = parseInt(String(val).split(".")[0], 10);
  const precision = String(val).split(".")[1];
  if (!precision) return val;
  if (precision.length > 2) {
    return `${integer}.${precision.substring(0, 2)}`;
  }
  return val;
};

export const nullIfNaN = val => (Number.isNaN(val) ? null : val);
```

## Fetching a collection of resources 👨‍👩‍👧‍👦

### Specifying scope 🔎

You can fetch resources from given scope in 3 ways:  

* by specifying scope in method calls e.g. `Coupon.get("all", {resource: "admin"})`
* setting up default scope on configuration stage _(see Configuration)_
* if you use **Loco-JS** you can set scope by calling `setScope "<scope name>"` controller's instance method. It's done in a namespace controller most often.

### Response formats 𝌮

Loco-JS-Model can handle responses in 2 JSON formats.

#### 1. an array of resources

```json
[
  {
    "id":101,
    "stripe_id":"my-project-20-dollar-off",
    "amount_off":20,
    "currency":"USD",
    "duration":"once",
    "duration_in_months":null,
    "max_redemptions":1,
    "percent_off":null,
    "redeem_by":null,
    "created_at":"2017-12-19T14:42:18.000Z",
    "updated_at":"2017-12-19T14:42:18.000Z"
  },
  ...
]
```

To fetch all resources you have to specify total number of records by using _total_ or _count_ keys.

```javascript
Coupon.get("all", {resource: "admin", planId: 6, total: 603}).then(coupons => {});
// GET "/admin/plans/6/coupons?current-page=1"
// GET "/admin/plans/6/coupons?current-page=2"
// GET "/admin/plans/6/coupons?current-page=3"
// ...
```

#### 2. with _resources_ and _count_ keys

```json
{
  "resources": [
    {
      "id":101,
      "stripe_id":"my-project-20-dollar-off",
      "amount_off":20,
      "currency":"USD",
      "duration":"once",
      "duration_in_months":null,
      "max_redemptions":1,
      "percent_off":null,
      "redeem_by":null,
      "created_at":"2017-12-19T14:42:18.000Z",
      "updated_at":"2017-12-19T14:42:18.000Z"
    },
    ...
  ],
  "count": 603
}
```

To fetch all resources you don't have to specify total number of records in this case, because API does it already.

```javascript
Coupon.get("all", {resource: "admin", planId: 6}).then(res => {
  res.resources; // all instances of Coupon
  res.count; // total number of coupons
});
// GET "/admin/plans/6/coupons?current-page=1"
// GET "/admin/plans/6/coupons?current-page=2"
// ...
```

### Fetching resources from other API endpoints

Just pass the name of the endpoint instead of _"all"_.  
This example also contains how to pass **additional parameters** to the request.

```javascript
Coupon.get("used", {total: 211, foo: "bar", baz: 13}).then(coupons => {});
// GET "/user/coupons/used?foo=bar&baz=13&page=1"
// GET "/user/coupons/used?foo=bar&baz=13&page=2"
// ...
```

### Fetching a specific page

Just pass a `page` param.

```javascript
Coupon.get("recent", {
  resource: "admin", 
  planId: 6, 
  total: 414, 
  page: 4, 
  foo: 10
}).then(coupons => {});
// GET "/admin/plans/6/coupons/recent?page=4&foo=10&current-page=4"
```

## Fetching a single resource 💃

Loco-JS-Model provides `find` static method for fetching a single resource. The response from the server should be in a plain JSON format with remote names of attributes as keys.

```javascript
Coupon.find(25).then(coupon => {});
// GET "/user/coupons/25"

// or pass an object

Coupon.find({id: 25}).then(coupon => {});
// GET "/user/coupons/25"

// You can also specify a resource and pass additional params 

Coupon.find({id: 25, resource: "admin", planId: 8, foo: 12, bar: "baz"}).then(coupon => {});
// GET "/admin/plans/8/coupons/25?foo=12&bar=baz"
```

## Sending requests 🏹

Every model inherits from `Models.Base` static and instance methods for sending `get` `post` `put` `patch` `delete` requests to the server.

```javascript
Coupon.patch("used", {resource: "admin", planId: 9, ids: [1,2,3,4]}).then(resp => {});
// PATCH "/admin/plans/9/coupons/used"
// Parameters: {"ids"=>[1, 2, 3, 4], "current-page"=>1, "plan_id"=>"9"}

Coupon.find({id: 25, resource: "admin", planId: 8}).then(coupon => {
  coupon.planId = 8; // set planId explicitly if API does not return it
  coupon.patch("use", {foo: "bar", baz: 102}).then(resp => {});
  // PATCH "/admin/plans/8/coupons/25/use"
  // Parameters: {"foo"=>"bar", "baz"=>102, "plan_id"=>"8", "id"=>"25"}
});
```

## Validations ✅

If attributes' validations are specified, you can use the `isValid` / `isInvalid` methods to check whether the model instance is valid or not.

```javascript
const coupon = new Coupon;
coupon.isValid();   // false 
coupon.isInvalid(); // true
coupon.errors; // {
               //   stripeId: ["can't be blank", "is not included in the list"], 
               //   duration: ["can't be blank", "is invalid"]
               // }
```

Loco-JS-Model implements almost all built-in [Rails](http://guides.rubyonrails.org/active_record_validations.html) validators, except of _uniqueness_. And you can use them nearly identically.  
You can also look at [source code](https://github.com/locoframework/loco-js-model/tree/master/src/validators) if you are looking for all available options. They are pretty straightforward to decipher.

## Saving ✍️

Loco-JS-Model provides `save` method that facilitates persisting resources on the server. This method requires responses in specific JSON format. I recommend to use the format below, but if you don't plan to use `UI.Form` from **Loco-JS** for handling forms, the only requirement is specified format of **errors** key to have errors assigned to the object.

```javascript
const coupon = new Coupon({
  resource: "admin",
  planId: 19,
  percentOff: 50
});
coupon.save().then(resp => {
// POST "/admin/plans/19/coupons"
// Parameters: { "coupon" => { "stripe_id"=>nil, "percent_off"=>50, "amount_off"=>nil,
//                             "duration"=>nil, "duration_in_months"=>nil,
//                             "max_redemptions"=>nil, "redeem_by"=>nil
//                           },
//               "plan_id" => "19"
//             }
  resp; // { success: false, 
        //   status: 400, 
        //   errors: {
        //     stripe_id: ["can't be blank", "is invalid"], 
        //     duration: ["can't be blank", "is not included in the list"]
        //   }
        // }
  coupon.errors; // { stripeId: ["can't be blank", "is not included in the list"], 
                 //   duration: ["can't be blank", "is invalid"]
                 // }
});
```

## Reloading ♻️

Loco-JS-Model provides a convenient method for reloading an object. The following example is quite self-explanatory.

```javascript
Coupon.find({id: 25, resource: "admin", planId: 8}).then(coupon => {
// GET "/admin/plans/8/coupons/25"
  coupon.planId = 8; // set planId explicitly if API does not return it
  coupon; // Coupon { ... id: 25, duration: "once", percentOff: 30 }

  // change percent_off and duration on the server and after some time ...

  setTimeout(() => {
    coupon.reload().then(coupon => {
    // GET "/admin/plans/8/coupons/25"
      coupon; // Coupon { ... id: 25, duration: "forever", percentOff: 50 }
    });
  }, 5000);
});
```

## 💥 Dirty object 🧙🏽‍♂️

This feature looks like a pure magic when you look at how this works for the first time.

_Dirty object_ is an ability of model instances to express how attribute values have been changed between 2 moments in time - when an object was initialized and their current value on the server.

It is especially useful when you use `Connectivity` features from Loco-JS.

Just look at the example below and bare in mind the order of things 💥

```javascript
// IN THE 1ST ORDER
Coupon.find({id: 25, resource: "admin", planId: 8}).then(coupon => {
  coupon; // Coupon { ... id: 25, duration: "once", percentOff: 30 }
  
  // IN THE 3RD ORDER
  setTimeout(() => {
    coupon.changes(); // { percentOff: { is: "forever", was: "once" }, 
                      //   duration: { is: 50, was: 30 }
                      // }
    coupon.applyChanges();
    coupon; // Coupon { ... id: 25, duration: "forever", percentOff: 50 }
  }, 6000);
});

// change percent_off and duration on the server and after some time ...

// IN THE 2ND ORDER
setTimeout(() => {
  Coupon.find({id: 25, resource: "admin", planId: 8}).then(coupon => {
    coupon; // Coupon { ... id: 25, duration: "forever", percentOff: 50 }
  });
}, 3000);

```

# 🇵🇱 i18n

Loco-JS-Model supports internationalization. Following example shows how to display errors in a different language.

First, create a translation of the [base English file](https://github.com/locoframework/loco-js-model/blob/master/src/locales/en.coffee).

```javascript
// locales/pl.js

const pl = {
  variants: {},
  attributes: {},
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

Loco-JS-Model must have all translations assigned to `I18n` object.

```javascript
import { Config, I18n } from "loco-js-model";

import pl from "locales/pl";

// remember to polyfill Object.assign or assign it in a different way
Object.assign(I18n, {
  pl
});

Config.locale = "pl";
```

```javascript
const coupon = new Coupon({ percentOff: 50 });
coupon.isValid(); // false
coupon.errors; // { duration: ["nie może być puste", "nie jest na liście dopuszczalnych wartości"] 
               //   stripeId: ["nie może być puste", "jest nieprawidłowe"]
               // }
```

# 👩🏽‍🔬 Tests

Like it's been said at the beginning, Loco-JS-Model has been extracted from Loco-JS. And Loco-JS is a front-end part of the whole Loco framework along with Loco-Rails.  
Both Loco-JS and Loco-Rails are pretty well tested. And because they work in cooperation with each other, they must be tested as one library (Loco-Rails has a suite of integration / _"end to end"_ tests). 

So every change made to Loco-JS-Model must be tested with Loco-JS' unit tests and then together as Loco framework it must be tested against Loco-Rails' integration test suite.

Future changes will also be tested with local unit tests, using [Jest](https://facebook.github.io/jest/) probably.

# 📈 Changelog

## Major releases 🎙

### 0.3.1

* 🎉 officially announced version 🎉

Informations about all releases are published on [Twitter](https://twitter.com/artofcode_co)

# 📜 License

Loco-JS-Model is released under the [MIT License](https://opensource.org/licenses/MIT).

# 👨‍🏭 Author

Zbigniew Humeniuk from [Art of Code](http://artofcode.co)