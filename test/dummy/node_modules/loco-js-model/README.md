![logo](https://raw.githubusercontent.com/artofcodelabs/artofcodelabs.github.io/master/assets/ext/loco_logo_trans_sqr-300px.png)

# 🚧 This documentation is under construction. Come back soon! 🚧

> Missing model layer for modern JavaScript

# 🧐 What is Loco-JS-Model?

It can be said that **Loco-JS-Model** is a model part of [**Loco-JS**](http://github.com/locoframework/loco-js), which __can be used separately__.  
**Loco-JS** is in turn a front-end part of [**Loco-Rails**](http://github.com/locoframework/loco-rails), which can be used separately as well.  
And **Loco-Rails** is a back-end part of the whole [**Loco**](http://github.com/locoframework) framework and it requires **Loco-JS** to work.

But **Loco-Rails** is just a concept to simplify communication between front-end and back-end code. You can implement it in other languages or frameworks as well.  
I am a Rails programmer that's why I created **Loco** for **Rails**.

This is how we can visualize this:

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

# 🦕 Origins

**Loco** framework has been created back in 2016. The main reason for it was to make my life easier as a full-stack developer.  
I was using [Coffeescript](http://coffeescript.org) back then on the front-end and [Ruby on Rails](http://rubyonrails.org) on the back-end.

I still use **Rails** but my front-end toolbox has changed to modern goodies such as **ES6**, [Webpack](https://webpack.js.org), [Babel](https://babeljs.io), [React](https://reactjs.org), [Redux](https://redux.js.org)... and **Loco-JS** obviously :)

**Loco-Rails** enriches Ruby on Rails. It's an another layer that works on top of Rails to simplify communication between front-end na back-end code. It is a concept that utilizes good parts of Rails to make this communication straightforward.

But you can use **Loco-JS** standalone to give your JavaScript a structure, for example.  
You can also use **Loco-JS-Model** without Rails, along with other modern tools such as React and Redux, by following only a few rules of formatting JSON responses from the server.

## But how is Loco supposed to help? ⛑

* by providing logical structure for JavaScript code. You exactly know where to start, when looking for JavaScript code that runs current page (**Loco-JS**)
* you have models that protect from sending invalid data to API endpoints. They also facilitate fetching objects of given type from server (**Loco-JS-Model**)
* you can easily assign model to form what enrich it with fields' validation (**Loco-JS**)
* you can connect models with controllers and views to be notified about every change made on given model and emitted to the front-end from the server (**Loco**)
* allows you to send messages over WebSockets in both way with one line of code (**Loco**)
* respect permissions (you can send messages only to specified, signed in on the server, models _e.g. given admin or user_) (**Loco**)
* solves other common problems

# 🔬 Tech stack of Loco-JS-Model

The Origins explain why the major part of **Loco-JS-Model** is still written in CoffeeScript.	 It is just an extraction from Loco-JS for everyone who don't need all the features that Loco-JS provides. BTW: Loco-JS has now more JavaScript than CoffeeScript inside. It shouldn't worry you though unless you want to contribute.

What's more important is that all Loco-JS-Model's modules are bundled and transpiled using modern tools such as **Webpack** and **Babel** accordingly. Loco-JS-Model works well as a part of modern JavaScript ecosystem alongside libraries such as React and Redux.  
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

# 📥 Instalation

```bash
$ npm install --save loco-js-model
```

# 🤝 Dependencies

🎊 Loco-JS-Model has no dependencies. 🎉  
Although, [class properties transform](https://babeljs.io/docs/plugins/transform-class-properties/) Babel plugin may be helpful to support static class properties, which are useful in how you define models.

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
// using this propertly.
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
    url: "/admin/coupons",
    main: {
      url:  '/coupons', 
      paginate: { per: 100, param: "current-page" }
    },
    user: {
      url: '/user/coupons', 
      paginate: { per: 10 }
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
          // you can run given validators conditionally
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

* by specifing scope in method calls e.g. `Coupon.get 'all', resource: 'main'`
* setting up default scope on configuration stage _(see Configuration)_
* if you use **Loco-JS** you can set scope by calling `setScope "<scope name>"` controller's instance method. It's done in a namespace controller most often.

### Response format 𝌮

Loco-JS-Model requires server response in a specific JSON format (with _resources_ and _count_ keys). Example:

```json
{
  "resources": [
  	{
  	  "id":21,
  	  "stripe_id":"my-project-20-perc",
  	  "amount_off":null,
  	  "currency":null,
  	  "duration":"once",
  	  "duration_in_months":null,
  	  "max_redemptions":null,
  	  "percent_off":20,
  	  "redeem_by":null,
  	  "created_at":"2018-01-23T12:28:55.000+01:00",
  	  "updated_at":"2018-01-23T12:28:55.000+01:00"
    },
    ...
  ],
  "count": 9
}
```

### API 🔗

```javascript
Coupon.get("all").then(res => {});
// GET "/admin/coupons?page=1"
// GET "/admin/coupons?page=2"
// GET "/admin/coupons?page=3"
// ...

// ...
```

## Validations ✅

...

# 🇵🇱 i18n

...

# 👩🏽‍🔬 Tests

...

# 📈 Changelog

...