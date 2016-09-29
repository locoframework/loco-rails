window.App = {
  Loco: null,
  IdentityMap: null,
  Wire: null,
  Line: null,
  Env: {
    loco: null,
    namespaceController: null,
    controller: null,
    action: null,
    scope: null
  },
  Mix: null,
  Mixins: {},
  UI: {},
  Controllers: {},
  Models: {},
  Views: {},
  Services: {},
  Helpers: {},
  Presenters: {},
  Validators: {},
  I18n: {},
  Utils: {},
  Channels: {
    Loco: {}
  }
};

var slice = [].slice,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

App.Mix = function() {
  var Mixed, base, i, method, mixin, mixins, name, ref;
  base = arguments[0], mixins = 2 <= arguments.length ? slice.call(arguments, 1) : [];
  Mixed = (function(superClass) {
    extend(Mixed, superClass);

    function Mixed() {
      return Mixed.__super__.constructor.apply(this, arguments);
    }

    return Mixed;

  })(base);
  for (i = mixins.length - 1; i >= 0; i += -1) {
    mixin = mixins[i];
    ref = mixin.prototype;
    for (name in ref) {
      method = ref[name];
      Mixed.prototype[name] = method;
    }
  }
  return Mixed;
};

App.IdentityMap = (function() {
  function IdentityMap() {}

  IdentityMap.imap = {};

  IdentityMap.clear = function() {
    return this.imap = {};
  };

  IdentityMap.add = function(obj) {
    var identity;
    identity = obj.getIdentity();
    if (this.imap[identity] == null) {
      this.imap[identity] = {};
    }
    if (this.imap[identity][obj.id] == null) {
      this.imap[identity][obj.id] = [];
    }
    return this.imap[identity][obj.id][0] = obj;
  };

  IdentityMap.connect = function(obj, opts) {
    var model;
    if (opts == null) {
      opts = {};
    }
    model = opts["with"];
    this.add(model);
    return this.imap[model.getIdentity()][model.id].push(obj);
  };

  IdentityMap.addCollection = function(identity, opts) {
    if (opts == null) {
      opts = {};
    }
    if (this.imap[identity] == null) {
      this.imap[identity] = {};
    }
    if (this.imap[identity]["collection"] == null) {
      this.imap[identity]["collection"] = [];
    }
    if (this.imap[identity]["collection"].indexOf(opts.to) !== -1) {
      return;
    }
    return this.imap[identity]["collection"].push(opts.to);
  };

  IdentityMap.all = function(identity) {
    var arr, id, objs, ref;
    if (this.imap[identity] == null) {
      return null;
    }
    arr = [];
    ref = this.imap[identity];
    for (id in ref) {
      objs = ref[id];
      if (id === "collection") {
        continue;
      }
      arr.push(objs[0]);
    }
    return arr;
  };

  IdentityMap.find = function(klass, id) {
    if (this.imap[klass] && this.imap[klass][id]) {
      return this.imap[klass][id][0];
    } else {
      return null;
    }
  };

  IdentityMap.findConnected = function(klass, id) {
    var arr;
    if (this.imap[klass] && this.imap[klass][id] && this.imap[klass][id].length > 1) {
      arr = this.imap[klass][id];
      return arr.slice(1, +(arr.length - 1) + 1 || 9e9);
    } else {
      return [];
    }
  };

  return IdentityMap;

})();

App.Wire = (function() {
  function Wire(opts) {
    var ref, ref1, ref2, ref3;
    if (opts == null) {
      opts = {};
    }
    this.syncTime = null;
    this.token = null;
    this.pollingInterval = null;
    this.pollingTime = (ref = opts.pollingTime) != null ? ref : 3000;
    this.log = (opts.log != null) && opts.log ? true : false;
    this.ssl = opts.ssl;
    this.location = (ref1 = opts.location) != null ? ref1 : 'notification-center';
    this.size = (ref2 = opts.size) != null ? ref2 : 100;
    this.protocolWithHost = opts.protocolWithHost;
    this.allowedDisconnectionTime = (ref3 = opts.allowedDisconnectionTime) != null ? ref3 : 10;
    this.disconnectedSinceTime = null;
  }

  Wire.prototype.setToken = function(token) {
    return this.token = token;
  };

  Wire.prototype.getSyncTime = function() {
    return this.syncTime;
  };

  Wire.prototype.resetSyncTime = function() {
    return this.syncTime = null;
  };

  Wire.prototype.getPollingTime = function() {
    return this.pollingTime;
  };

  Wire.prototype.setPollingTime = function(val) {
    this.pollingTime = val;
    this.disconnect();
    return this.connect();
  };

  Wire.prototype.getPollingInterval = function() {
    return this.pollingInterval;
  };

  Wire.prototype.getSSL = function() {
    return this.ssl;
  };

  Wire.prototype.setSSL = function(val) {
    return this.ssl = val;
  };

  Wire.prototype.getLocation = function() {
    return this.location;
  };

  Wire.prototype.setLocation = function(val) {
    return this.location = val;
  };

  Wire.prototype.getSize = function() {
    return this.size;
  };

  Wire.prototype.setSize = function(val) {
    return this.size = val;
  };

  Wire.prototype.getAllowedDisconnectionTime = function() {
    return this.allowedDisconnectionTime;
  };

  Wire.prototype.setAllowedDisconnectionTime = function(val) {
    return this.allowedDisconnectionTime = val;
  };

  Wire.prototype.connect = function() {
    return this.pollingInterval = setInterval((function(_this) {
      return function() {
        return _this._check();
      };
    })(this), this.pollingTime);
  };

  Wire.prototype.disconnect = function() {
    return window.clearInterval(this.pollingInterval);
  };

  Wire.prototype.disableNotifications = function() {
    console.log('App.Wire#disableNotifications - DEPRECATED');
    return this.disconnect();
  };

  Wire.prototype.processNotification = function(notification) {
    var className, id, identity, model, obj, payload, signal;
    if (this.log) {
      console.log(notification);
    }
    className = notification[0], id = notification[1], signal = notification[2], payload = notification[3];
    model = App.Env.loco.getModelForRemoteName(className);
    identity = model.getIdentity();
    if (App.IdentityMap.imap[identity] == null) {
      return;
    }
    if (App.IdentityMap.imap[identity][id] != null) {
      obj = App.IdentityMap.find(identity, id);
      if (obj["receivedSignal"] != null) {
        obj.receivedSignal(signal, payload);
      }
      this._emitSignalToMembers(id, signal, payload, model, identity);
    }
    if (model["receivedSignal"] != null) {
      model.receivedSignal(signal, payload);
    }
    if (App.IdentityMap.imap[identity]["collection"] == null) {
      return;
    }
    if (App.IdentityMap.imap[identity]["collection"].length === 0) {
      return;
    }
    return this._emitSignalToCollection(signal, payload, identity);
  };

  Wire.prototype.processSignal = function(notification) {
    return this.processNotification(notification);
  };

  Wire.prototype._check = function() {
    var jqxhr;
    if (Object.keys(App.IdentityMap.imap).length === 0 && (this.token == null) && (this.syncTime != null)) {
      return;
    }
    jqxhr = $.ajax({
      method: "GET",
      url: this._getURL(),
      data: this._requestParams()
    });
    jqxhr.always(function() {});
    jqxhr.fail((function(_this) {
      return function() {
        return _this._handleDisconnection();
      };
    })(this));
    return jqxhr.done((function(_this) {
      return function(data) {
        var i, len, notification, notifications;
        _this.disconnectedSinceTime = null;
        _this.syncTime = data[1];
        notifications = data[0];
        if (notifications.length === 0) {
          return;
        }
        for (i = 0, len = notifications.length; i < len; i++) {
          notification = notifications[i];
          _this.processNotification(notification);
        }
        if (notifications.length === _this.size) {
          return _this._check();
        }
      };
    })(this));
  };

  Wire.prototype._emitSignalToMembers = function(id, signal, payload, model, identity, obj) {
    var connObj, i, len, ref, results;
    if (obj == null) {
      obj = null;
    }
    if (obj == null) {
      obj = new model({
        id: id
      });
    }
    ref = App.IdentityMap.findConnected(identity, id);
    results = [];
    for (i = 0, len = ref.length; i < len; i++) {
      connObj = ref[i];
      if (connObj.receiverFor(obj) != null) {
        results.push(connObj[connObj.receiverFor(obj)](signal, payload));
      } else if (connObj["receivedSignal"] != null) {
        results.push(connObj.receivedSignal(signal, payload));
      } else {
        results.push(void 0);
      }
    }
    return results;
  };

  Wire.prototype._emitSignalToCollection = function(signal, payload, identity) {
    var i, len, obj, ref, results;
    ref = App.IdentityMap.imap[identity]["collection"];
    results = [];
    for (i = 0, len = ref.length; i < len; i++) {
      obj = ref[i];
      if (obj.receiverFor(identity) != null) {
        results.push(obj[obj.receiverFor(identity)](identity + " " + signal, payload));
      } else if (obj["receivedSignal"] != null) {
        results.push(obj.receivedSignal(identity + " " + signal, payload));
      } else {
        results.push(void 0);
      }
    }
    return results;
  };

  Wire.prototype._requestParams = function() {
    var params;
    params = {
      synced_at: this.syncTime
    };
    if (this.token != null) {
      params["token"] = this.token;
    }
    return params;
  };

  Wire.prototype._getURL = function() {
    var _, host, protocol, ref, ref1;
    ref = window.location.href.split('/'), protocol = ref[0], _ = ref[1], host = ref[2];
    if (this.protocolWithHost != null) {
      ref1 = this.protocolWithHost.split('//'), protocol = ref1[0], host = ref1[1];
    }
    if (this.ssl != null) {
      protocol = this.ssl ? 'https:' : "http:";
    }
    return protocol + "//" + host + "/" + this.location;
  };

  Wire.prototype._handleDisconnection = function() {
    var ctrl, diffInSec, ref;
    if (this.disconnectedSinceTime == null) {
      this.disconnectedSinceTime = new Date();
    }
    diffInSec = (new Date() - this.disconnectedSinceTime) / 1000;
    ctrl = (ref = App.Env.namespaceController) != null ? ref : App.Env.controller;
    if (diffInSec > this.allowedDisconnectionTime && (ctrl['disconnectedForTooLong'] != null)) {
      return ctrl.disconnectedForTooLong(this.disconnectedSinceTime);
    }
  };

  return Wire;

})();

App.Line = (function() {
  function Line(opts) {
    if (opts == null) {
      opts = {};
    }
  }

  Line.prototype.connect = function() {
    return App.Channels.Loco.NotificationCenter = App.cable.subscriptions.create({
      channel: "Loco::NotificationCenterChannel"
    }, {
      connected: function() {
        return console.log('connected');
      },
      disconnected: function() {
        return console.log('disconnected');
      },
      received: function(data) {
        var plug;
        plug = new App.Services.Plug;
        return plug.receivedSignal(data);
      }
    });
  };

  return Line;

})();

App.Loco = (function() {
  function Loco(opts) {
    var notificationsParams, ref, ref1, ref2, ref3;
    if (opts == null) {
      opts = {};
    }
    this.wire = null;
    this.line = null;
    this.locale = null;
    this.turbolinks = (ref = opts.turbolinks) != null ? ref : false;
    this.initWire = ((ref1 = opts.notifications) != null ? ref1.enable : void 0) ? true : false;
    this.postInit = opts.postInit;
    this.setLocale((ref2 = opts.locale) != null ? ref2 : 'en');
    this.setProtocolWithHost(opts.protocolWithHost);
    notificationsParams = (ref3 = opts.notifications) != null ? ref3 : {};
    notificationsParams.protocolWithHost = this.protocolWithHost;
    this.notificationsParams = notificationsParams;
  }

  Loco.prototype.getWire = function() {
    return this.wire;
  };

  Loco.prototype.getLocale = function() {
    return this.locale;
  };

  Loco.prototype.setLocale = function(locale) {
    return this.locale = locale;
  };

  Loco.prototype.getProtocolWithHost = function() {
    return this.protocolWithHost;
  };

  Loco.prototype.setProtocolWithHost = function(val) {
    if (val == null) {
      this.protocolWithHost = null;
      return;
    }
    if (val[val.length - 1] === '/') {
      val = val.slice(0, +(val.length - 2) + 1 || 9e9);
    }
    return this.protocolWithHost = val;
  };

  Loco.prototype.init = function() {
    var event;
    App.Env.loco = this;
    if (this.initWire) {
      this.wire = new App.Wire(this.notificationsParams);
      this.wire.connect();
    }
    if (App.cable != null) {
      this.line = new App.Line;
      this.line.connect();
    }
    if (this.turbolinks) {
      event = Number(this.turbolinks) >= 5 ? "turbolinks:load" : "page:change";
      return jQuery(document).on(event, (function(_this) {
        return function() {
          _this.flow();
          if (_this.postInit != null) {
            return _this.postInit();
          }
        };
      })(this));
    } else {
      return jQuery((function(_this) {
        return function() {
          _this.flow();
          if (_this.postInit != null) {
            return _this.postInit();
          }
        };
      })(this));
    }
  };

  Loco.prototype.flow = function() {
    var action_name, controller_name, namespace_name;
    App.IdentityMap.clear();
    namespace_name = $('body').data('namespace');
    controller_name = $('body').data('controller');
    action_name = $('body').data('action');
    App.Env.action = action_name;
    if (App.Controllers[namespace_name] != null) {
      App.Env.namespaceController = new App.Controllers[namespace_name];
      if (App.Controllers[namespace_name][controller_name] != null) {
        App.Env.controller = new App.Controllers[namespace_name][controller_name];
      }
      if (App.Env.namespaceController.initialize != null) {
        App.Env.namespaceController.initialize();
      }
      if (App.Env.controller != null) {
        App.Env.namespaceController.setSubController(App.Env.controller);
        App.Env.controller.setSuperController(App.Env.namespaceController);
        if (App.Env.controller.initialize != null) {
          App.Env.controller.initialize();
        }
        if (App.Env.controller[action_name] != null) {
          App.Env.controller[action_name]();
        }
      }
    } else if (App.Controllers[controller_name]) {
      App.Env.controller = new App.Controllers[controller_name];
      if (App.Env.controller.initialize != null) {
        App.Env.controller.initialize();
      }
      if (App.Env.controller[action_name] != null) {
        App.Env.controller[action_name]();
      }
    }
    if (this.wire != null) {
      this.wire.resetSyncTime();
      return this.wire._check();
    }
  };

  Loco.prototype.emit = function(data) {
    return App.Channels.Loco.NotificationCenter.send(data);
  };

  Loco.prototype.getModels = function() {
    var _, func, innerFunc, models, ref, ref1, regExp;
    models = [];
    regExp = /^[A-Z]/;
    ref = App.Models;
    for (func in ref) {
      _ = ref[func];
      if (!regExp.exec(func) || func === "Base") {
        continue;
      }
      models.push(func);
      ref1 = App.Models[func];
      for (innerFunc in ref1) {
        _ = ref1[innerFunc];
        if (regExp.exec(innerFunc)) {
          models.push(func + "." + innerFunc);
        }
      }
    }
    return models;
  };

  Loco.prototype.getModelForRemoteName = function(remoteName) {
    var i, len, model, parts, ref;
    ref = this.getModels();
    for (i = 0, len = ref.length; i < len; i++) {
      model = ref[i];
      parts = model.split(".");
      if (parts.length === 1) {
        if (App.Models[parts[0]].getRemoteName() === remoteName) {
          return App.Models[parts[0]];
        }
      } else if (parts.length === 2) {
        if (App.Models[parts[0]][parts[1]].getRemoteName() === remoteName) {
          return App.Models[parts[0]][parts[1]];
        }
      }
    }
  };

  return Loco;

})();

App.Mixins.Connectivity = (function() {
  function Connectivity() {}

  Connectivity.prototype.connectWith = function(data, opts) {
    var i, identity, len, ref;
    if (opts == null) {
      opts = {};
    }
    if (data == null) {
      return null;
    }
    if (data.constructor.name === "Array") {
      ref = App.Utils.Array.uniq(App.Utils.Array.map(data, function(obj) {
        return obj.getIdentity();
      }));
      for (i = 0, len = ref.length; i < len; i++) {
        identity = ref[i];
        App.IdentityMap.addCollection(identity, {
          to: this
        });
        if (opts.receiver != null) {
          this.receivers[identity] = opts.receiver;
        }
      }
      return;
    }
    if (opts.receiver != null) {
      this.receivers[data.toKey()] = opts.receiver;
    }
    return App.IdentityMap.connect(this, {
      "with": data
    });
  };

  Connectivity.prototype.receiverFor = function(data) {
    if (data.constructor.name === "String") {
      if (this.receivers[data] != null) {
        return this.receivers[data];
      } else {
        return null;
      }
    }
    if (this.receivers[data.toKey()] != null) {
      return this.receivers[data.toKey()];
    }
    return null;
  };

  return Connectivity;

})();

App.Utils.Array = (function() {
  function Array() {}

  Array.map = function(arr, func) {
    var i, len, newArr, o;
    newArr = [];
    for (i = 0, len = arr.length; i < len; i++) {
      o = arr[i];
      newArr.push(func(o));
    }
    return newArr;
  };

  Array.uniq = function(arr) {
    var i, len, newArr, o;
    newArr = [];
    for (i = 0, len = arr.length; i < len; i++) {
      o = arr[i];
      if (newArr.indexOf(o) === -1) {
        newArr.push(o);
      }
    }
    return newArr;
  };

  return Array;

})();

App.Utils.Collection = (function() {
  function Collection() {}

  Collection.find = function(collection, func) {
    var i, len, o;
    for (i = 0, len = collection.length; i < len; i++) {
      o = collection[i];
      if (func(o) === true) {
        return o;
      }
    }
  };

  return Collection;

})();

App.Utils.String = (function() {
  function String() {}

  String.last = function(s) {
    return s[s.length - 1];
  };

  return String;

})();

App.Validators.Base = (function() {
  Base.sharedInstances = {};

  Base.instance = function(obj, attr, opts) {
    var sharedInstance, validatorName;
    validatorName = this.name;
    if (this.sharedInstances[validatorName] == null) {
      this.sharedInstances[validatorName] = new App.Validators[validatorName];
    }
    sharedInstance = this.sharedInstances[validatorName];
    sharedInstance.assignAttribs(obj, attr, opts);
    return sharedInstance;
  };

  function Base() {
    this.obj = null;
    this.attr = null;
    this.val = null;
    this.opts = null;
  }

  Base.prototype.assignAttribs = function(obj, attr, opts) {
    this.obj = obj;
    this.attr = attr;
    this.val = this.obj[this.attr];
    return this.opts = opts;
  };

  return Base;

})();

var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

App.Validators.Absence = (function(superClass) {
  extend(Absence, superClass);

  function Absence() {
    Absence.__super__.constructor.apply(this, arguments);
  }

  Absence.prototype.validate = function() {
    switch (typeof this.val) {
      case 'string':
        if ((this.val != null) && this.val.length === 0) {
          return;
        }
        break;
      default:
        if (this.val == null) {
          return;
        }
    }
    return this._addErrorMessage();
  };

  Absence.prototype._addErrorMessage = function() {
    var message;
    message = this.opts.message != null ? this.opts.message : App.I18n[App.Env.loco.getLocale()].errors.messages.present;
    return this.obj.addErrorMessage(message, {
      "for": this.attr
    });
  };

  return Absence;

})(App.Validators.Base);

var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

App.Validators.Confirmation = (function(superClass) {
  extend(Confirmation, superClass);

  function Confirmation() {
    Confirmation.__super__.constructor.apply(this, arguments);
  }

  Confirmation.prototype.validate = function() {
    var properVal;
    properVal = this.obj[this._properAttr()];
    if ((this.val != null) && (properVal != null) && this.val === properVal) {
      return;
    }
    return this._addErrorMessage();
  };

  Confirmation.prototype._addErrorMessage = function() {
    var attrName, attrNames, defaultAttrName, message;
    defaultAttrName = this.attr.charAt(0).toUpperCase() + this.attr.slice(1);
    attrNames = App.I18n[App.Env.loco.getLocale()].attributes[this.obj.getIdentity()];
    attrName = (attrNames && attrNames[this.attr]) || defaultAttrName;
    message = this.opts.message != null ? this.opts.message : App.I18n[App.Env.loco.getLocale()].errors.messages.confirmation;
    message = message.replace('%{attribute}', attrName);
    return this.obj.addErrorMessage(message, {
      "for": this._properAttr()
    });
  };

  Confirmation.prototype._properAttr = function() {
    return this.attr + "Confirmation";
  };

  return Confirmation;

})(App.Validators.Base);

var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

App.Validators.Exclusion = (function(superClass) {
  extend(Exclusion, superClass);

  function Exclusion() {
    Exclusion.__super__.constructor.apply(this, arguments);
  }

  Exclusion.prototype.validate = function() {
    var set;
    set = this.opts["in"] || this.opts.within || [];
    if (set.indexOf(this.val) === -1) {
      return;
    }
    return this._addErrorMessage();
  };

  Exclusion.prototype._addErrorMessage = function() {
    var message;
    message = this.opts.message != null ? this.opts.message : App.I18n[App.Env.loco.getLocale()].errors.messages.exclusion;
    return this.obj.addErrorMessage(message, {
      "for": this.attr
    });
  };

  return Exclusion;

})(App.Validators.Base);

var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

App.Validators.Format = (function(superClass) {
  extend(Format, superClass);

  function Format() {
    Format.__super__.constructor.apply(this, arguments);
  }

  Format.prototype.validate = function() {
    var match;
    match = this.opts["with"].exec(this.val);
    if (match != null) {
      return;
    }
    return this._addErrorMessage();
  };

  Format.prototype._addErrorMessage = function() {
    var message;
    message = this.opts.message != null ? this.opts.message : App.I18n[App.Env.loco.getLocale()].errors.messages.invalid;
    return this.obj.addErrorMessage(message, {
      "for": this.attr
    });
  };

  return Format;

})(App.Validators.Base);

var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

App.Validators.Inclusion = (function(superClass) {
  extend(Inclusion, superClass);

  function Inclusion() {
    Inclusion.__super__.constructor.apply(this, arguments);
  }

  Inclusion.prototype.validate = function() {
    var set;
    set = this.opts["in"] || this.opts.within || [];
    if (set.indexOf(this.val) !== -1) {
      return;
    }
    return this._addErrorMessage();
  };

  Inclusion.prototype._addErrorMessage = function() {
    var message;
    message = this.opts.message != null ? this.opts.message : App.I18n[App.Env.loco.getLocale()].errors.messages.inclusion;
    return this.obj.addErrorMessage(message, {
      "for": this.attr
    });
  };

  return Inclusion;

})(App.Validators.Base);

var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

App.Validators.Length = (function(superClass) {
  extend(Length, superClass);

  function Length() {
    Length.__super__.constructor.apply(this, arguments);
  }

  Length.prototype.validate = function() {
    var message;
    if (this.val == null) {
      return;
    }
    message = (this._range()[0] != null) && (this._range()[1] != null) && this._range()[0] === this._range()[1] && this.val.length !== this._range()[0] ? this._selectErrorMessage('wrong_length', this._range()[0]) : (this._range()[0] != null) && this.val.length < this._range()[0] ? this._selectErrorMessage('too_short', this._range()[0]) : (this._range()[1] != null) && this.val.length > this._range()[1] ? this._selectErrorMessage('too_long', this._range()[1]) : null;
    if (message === null) {
      return;
    }
    return this.obj.addErrorMessage(message, {
      "for": this.attr
    });
  };

  Length.prototype._range = function() {
    var from, to;
    from = this.opts.minimum || this.opts.is || ((this.opts.within != null) && this.opts.within[0]) || null;
    to = this.opts.maximum || this.opts.is || ((this.opts.within != null) && this.opts.within[1]) || null;
    return [from, to];
  };

  Length.prototype._selectErrorMessage = function(msg, val) {
    var i, len, message, ref, variant;
    if (val === 1) {
      return App.I18n[App.Env.loco.getLocale()].errors.messages[msg].one;
    }
    message = null;
    ref = ['few', 'many'];
    for (i = 0, len = ref.length; i < len; i++) {
      variant = ref[i];
      if (this._checkVariant(variant, val)) {
        message = App.I18n[App.Env.loco.getLocale()].errors.messages[msg][variant];
        break;
      }
    }
    if (message == null) {
      message = App.I18n[App.Env.loco.getLocale()].errors.messages[msg].other;
    }
    if (this.opts.message != null) {
      message = this.opts.message;
    }
    if (/%{count}/.exec(message)) {
      message = message.replace('%{count}', val);
    }
    return message;
  };

  Length.prototype._checkVariant = function(variant, val) {
    if (App.I18n[App.Env.loco.getLocale()].variants[variant] == null) {
      return;
    }
    return App.I18n[App.Env.loco.getLocale()].variants[variant](val);
  };

  return Length;

})(App.Validators.Base);

var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

App.Validators.Numericality = (function(superClass) {
  extend(Numericality, superClass);

  function Numericality() {
    Numericality.__super__.constructor.apply(this, arguments);
  }

  Numericality.prototype.validate = function() {
    if (isNaN(this.val)) {
      return this._addNaNErrorMessage();
    } else if ((this.opts.only_integer != null) && Number(this.val) !== parseInt(this.val)) {
      return this._addIntErrorMessage();
    } else if ((this.opts.greater_than != null) && Number(this.val) <= this.opts.greater_than) {
      return this._addGreatherThanErrorMessage();
    } else if ((this.opts.greater_than_or_equal_to != null) && Number(this.val) < this.opts.greater_than_or_equal_to) {
      return this._addGreatherThanOrEqualToErrorMessage();
    } else if ((this.opts.equal_to != null) && Number(this.val) !== this.opts.equal_to) {
      return this._addEqualToErrorMessage();
    } else if ((this.opts.less_than != null) && Number(this.val) >= this.opts.less_than) {
      return this._addLessThanErrorMessage();
    } else if ((this.opts.less_than_or_equal_to != null) && Number(this.val) > this.opts.less_than_or_equal_to) {
      return this._addLessThanOrEqualToErrorMessage();
    } else if ((this.opts.other_than != null) && Number(this.val) === this.opts.other_than) {
      return this._addOtherThanErrorMessage();
    } else if ((this.opts.odd != null) && Number(this.val) % 2 !== 1) {
      return this._addOddErrorMessage();
    } else if ((this.opts.even != null) && Number(this.val) % 2 !== 0) {
      return this._addEvenErrorMessage();
    }
  };

  Numericality.prototype._addNaNErrorMessage = function() {
    var message;
    message = this.opts.message != null ? this.opts.message : App.I18n[App.Env.loco.getLocale()].errors.messages.not_a_number;
    return this.obj.addErrorMessage(message, {
      "for": this.attr
    });
  };

  Numericality.prototype._addIntErrorMessage = function() {
    var message;
    message = App.I18n[App.Env.loco.getLocale()].errors.messages.not_an_integer;
    return this.obj.addErrorMessage(message, {
      "for": this.attr
    });
  };

  Numericality.prototype._addGreatherThanErrorMessage = function() {
    var message;
    message = App.I18n[App.Env.loco.getLocale()].errors.messages.greater_than;
    message = message.replace('%{count}', this.opts.greater_than);
    return this.obj.addErrorMessage(message, {
      "for": this.attr
    });
  };

  Numericality.prototype._addGreatherThanOrEqualToErrorMessage = function() {
    var message;
    message = App.I18n[App.Env.loco.getLocale()].errors.messages.greater_than_or_equal_to;
    message = message.replace('%{count}', this.opts.greater_than_or_equal_to);
    return this.obj.addErrorMessage(message, {
      "for": this.attr
    });
  };

  Numericality.prototype._addEqualToErrorMessage = function() {
    var message;
    message = App.I18n[App.Env.loco.getLocale()].errors.messages.equal_to;
    message = message.replace('%{count}', this.opts.equal_to);
    return this.obj.addErrorMessage(message, {
      "for": this.attr
    });
  };

  Numericality.prototype._addLessThanErrorMessage = function() {
    var message;
    message = App.I18n[App.Env.loco.getLocale()].errors.messages.less_than;
    message = message.replace('%{count}', this.opts.less_than);
    return this.obj.addErrorMessage(message, {
      "for": this.attr
    });
  };

  Numericality.prototype._addLessThanOrEqualToErrorMessage = function() {
    var message;
    message = App.I18n[App.Env.loco.getLocale()].errors.messages.less_than_or_equal_to;
    message = message.replace('%{count}', this.opts.less_than_or_equal_to);
    return this.obj.addErrorMessage(message, {
      "for": this.attr
    });
  };

  Numericality.prototype._addOtherThanErrorMessage = function() {
    var message;
    message = App.I18n[App.Env.loco.getLocale()].errors.messages.other_than;
    message = message.replace('%{count}', this.opts.other_than);
    return this.obj.addErrorMessage(message, {
      "for": this.attr
    });
  };

  Numericality.prototype._addOddErrorMessage = function() {
    var message;
    message = App.I18n[App.Env.loco.getLocale()].errors.messages.odd;
    return this.obj.addErrorMessage(message, {
      "for": this.attr
    });
  };

  Numericality.prototype._addEvenErrorMessage = function() {
    var message;
    message = App.I18n[App.Env.loco.getLocale()].errors.messages.even;
    return this.obj.addErrorMessage(message, {
      "for": this.attr
    });
  };

  return Numericality;

})(App.Validators.Base);

var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

App.Validators.Presence = (function(superClass) {
  extend(Presence, superClass);

  function Presence() {
    Presence.__super__.constructor.apply(this, arguments);
  }

  Presence.prototype.validate = function() {
    switch (typeof this.val) {
      case 'string':
        if ((this.val != null) && this.val.length > 0) {
          return;
        }
        break;
      default:
        if (this.val != null) {
          return;
        }
    }
    return this._addErrorMessage();
  };

  Presence.prototype._addErrorMessage = function() {
    var message;
    message = this.opts.message != null ? this.opts.message : App.I18n[App.Env.loco.getLocale()].errors.messages.blank;
    return this.obj.addErrorMessage(message, {
      "for": this.attr
    });
  };

  return Presence;

})(App.Validators.Base);

var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

App.Validators.Size = (function(superClass) {
  extend(Size, superClass);

  function Size() {
    Size.__super__.constructor.apply(this, arguments);
  }

  Size.prototype.validate = function() {
    return App.Validators.Length.instance(this.obj, this.attr, this.opts).validate();
  };

  return Size;

})(App.Validators.Base);

App.Models.Base = (function() {
  function Base(data) {
    if (data == null) {
      data = {};
    }
    this.id = null;
    this.errors = null;
    this.resource = data.resource;
    if (this.constructor.attributes != null) {
      this.__initAttributes();
    }
    if (data != null) {
      this.__assignAttributes(data);
    }
  }

  Base.all = function(opts) {
    if (opts == null) {
      opts = {};
    }
    return this.get("all", opts);
  };

  Base.find = function(idOrObj) {
    var id, jqxhr, urlParams;
    urlParams = {};
    if (typeof idOrObj === "object") {
      urlParams = idOrObj;
      id = idOrObj.id;
      delete urlParams.id;
    } else {
      id = idOrObj;
    }
    jqxhr = $.ajax({
      dataType: 'json',
      method: 'GET',
      url: (this.__getResourcesUrl(urlParams)) + "/" + id,
      data: urlParams
    });
    return new Promise((function(_this) {
      return function(resolve, reject) {
        jqxhr.fail(function(xhr) {
          return reject(xhr);
        });
        return jqxhr.done(function(record) {
          var obj;
          obj = _this.__initSubclass(record);
          App.IdentityMap.add(obj);
          return resolve(obj);
        });
      };
    })(this));
  };

  Base.get = function(action, opts) {
    if (opts == null) {
      opts = {};
    }
    return this.__send("GET", action, opts);
  };

  Base.post = function(action, opts) {
    if (opts == null) {
      opts = {};
    }
    return this.__send("POST", action, opts);
  };

  Base.put = function(action, opts) {
    if (opts == null) {
      opts = {};
    }
    return this.__send("PUT", action, opts);
  };

  Base["delete"] = function(action, opts) {
    if (opts == null) {
      opts = {};
    }
    return this.__send("DELETE", action, opts);
  };

  Base.getIdentity = function() {
    if (this.identity != null) {
      return this.identity;
    } else {
      throw "Specify Model's @identity!";
    }
  };

  Base.getRemoteName = function() {
    if (this.remoteName != null) {
      return this.remoteName;
    } else {
      return this.getIdentity();
    }
  };

  Base.getAttribRemoteName = function(attrib) {
    if (this.attributes == null) {
      return null;
    }
    if (this.attributes[attrib] == null) {
      return null;
    }
    if (this.attributes[attrib].remoteName == null) {
      return attrib;
    }
    return this.attributes[attrib].remoteName;
  };

  Base.getResourcesUrlParams = function() {
    var match, params, regexp, url;
    url = this.__getResourcesUrl();
    regexp = /:(\w+)\/?/;
    params = [];
    while (match = regexp.exec(url)) {
      params.push(match[1]);
      url = url.replace(match[0], match[1]);
    }
    return params;
  };

  Base.__getResourcesUrl = function(opts) {
    var match, resourcesUrl;
    if (opts == null) {
      opts = {};
    }
    resourcesUrl = this.resources == null ? "/" + (this.getRemoteName().toLowerCase()) + "s" : opts.resource ? this.resources[opts.resource].url : (App.Env.scope != null) && (this.resources[App.Env.scope] != null) ? this.resources[App.Env.scope].url : this.resources.url;
    if (App.Env.loco.protocolWithHost != null) {
      resourcesUrl = "" + App.Env.loco.protocolWithHost + resourcesUrl;
    }
    match = /:(\w+)\/?/.exec(resourcesUrl);
    if (match == null) {
      return resourcesUrl;
    }
    if (opts[match[1]] != null) {
      resourcesUrl = resourcesUrl.replace(":" + match[1], opts[match[1]]);
      delete opts[match[1]];
    } else if ((opts.obj != null) && (opts.obj[match[1]] != null)) {
      resourcesUrl = resourcesUrl.replace(":" + match[1], opts.obj[match[1]]);
    }
    return resourcesUrl;
  };

  Base.__initSubclass = function(params) {
    var parts;
    if (params == null) {
      params = {};
    }
    parts = this.getIdentity().split(".");
    if (parts.length === 1) {
      return new App.Models[parts[0]](params);
    }
    return new App.Models[parts[0]][parts[1]](params);
  };

  Base.__page = function(i, opts, reqOpts, resp) {
    var data, httpMethod, jqxhr, key, ref, url, val;
    if (opts == null) {
      opts = {};
    }
    if (reqOpts == null) {
      reqOpts = {};
    }
    if (resp == null) {
      resp = {
        resources: [],
        count: 0
      };
    }
    httpMethod = reqOpts.method || "GET";
    url = reqOpts.url || this.__getResourcesUrl(opts);
    data = {};
    if (reqOpts.data != null) {
      ref = reqOpts.data;
      for (key in ref) {
        val = ref[key];
        if (key === "resource") {
          continue;
        }
        data[key] = val;
      }
    }
    data[this.__getPaginationParam()] = i;
    jqxhr = $.ajax({
      dataType: "json",
      method: httpMethod,
      url: url,
      data: data
    });
    return new Promise((function(_this) {
      return function(resolve, reject) {
        jqxhr.fail(function(xhr) {
          return reject(xhr);
        });
        return jqxhr.done(function(data) {
          var j, len, obj, record, ref1;
          resp.count = data.count;
          for (key in data) {
            val = data[key];
            if (['resources', 'count'].indexOf(key) === -1) {
              resp[key] = val;
            }
          }
          ref1 = data.resources;
          for (j = 0, len = ref1.length; j < len; j++) {
            record = ref1[j];
            obj = _this.__initSubclass(record);
            if (opts.resource != null) {
              obj.resource = opts.resource;
            }
            App.IdentityMap.add(obj);
            resp.resources.push(obj);
          }
          return resolve(resp);
        });
      };
    })(this));
  };

  Base.__paginate = function(opts, reqOpts) {
    var pageNum, perPage, ref;
    perPage = this.__getPaginationPer();
    pageNum = (ref = opts.page) != null ? ref : 1;
    return this.__page(pageNum, opts, reqOpts).then((function(_this) {
      return function(data) {
        var func, i, j, max, promise, ref1;
        if (opts.page != null) {
          return Promise.resolve(data);
        }
        if (data.count <= perPage) {
          return Promise.resolve(data);
        }
        max = parseInt(data.count / perPage);
        if (max !== data.count / perPage) {
          max += 1;
        }
        promise = Promise.resolve(data);
        if (max === 1) {
          return promise;
        }
        for (i = j = 2, ref1 = max; 2 <= ref1 ? j <= ref1 : j >= ref1; i = 2 <= ref1 ? ++j : --j) {
          func = function(i) {
            return promise = promise.then(function(arr) {
              return _this.__page(i, opts, reqOpts, data);
            });
          };
          func(i);
        }
        return promise;
      };
    })(this));
  };

  Base.__getPaginationParam = function() {
    var defaultParam, param, ref, ref1, ref2, ref3;
    defaultParam = 'page';
    if ((App.Env.scope != null) && (this.resources != null) && (this.resources[App.Env.scope] != null)) {
      param = (ref = this.resources[App.Env.scope]) != null ? (ref1 = ref.paginate) != null ? ref1.param : void 0 : void 0;
      return param != null ? param : defaultParam;
    }
    if (((ref2 = this.resources) != null ? (ref3 = ref2.paginate) != null ? ref3.param : void 0 : void 0) != null) {
      return this.resources.paginate.param;
    }
    return defaultParam;
  };

  Base.__getPaginationPer = function() {
    var ref, ref1, ref2, ref3;
    if ((App.Env.scope != null) && (this.resources != null) && (this.resources[App.Env.scope] != null)) {
      return (ref = this.resources[App.Env.scope]) != null ? (ref1 = ref.paginate) != null ? ref1.per : void 0 : void 0;
    }
    if (((ref2 = this.resources) != null ? (ref3 = ref2.paginate) != null ? ref3.per : void 0 : void 0) != null) {
      return this.resources.paginate.per;
    }
    return null;
  };

  Base.__send = function(method, action, opts) {
    var reqOpts, url;
    url = this.__getResourcesUrl(opts);
    if (action !== "all") {
      url = url + "/" + action;
    }
    reqOpts = {
      method: method,
      url: url,
      data: opts
    };
    return this.__paginate(opts, reqOpts);
  };

  Base.prototype.setResource = function(name) {
    return this.resource = name;
  };

  Base.prototype.getIdentity = function() {
    return this.constructor.identity;
  };

  Base.prototype.getAttrRemoteName = function(attr) {
    if (this.constructor.attributes == null) {
      return null;
    }
    if (this.constructor.attributes[attr] == null) {
      return null;
    }
    return this.constructor.attributes[attr].remoteName || attr;
  };

  Base.prototype.getAttrName = function(remoteName) {
    var config, name, ref;
    if (this.constructor.attributes == null) {
      return remoteName;
    }
    if (this.constructor.attributes[remoteName] != null) {
      return remoteName;
    }
    ref = this.constructor.attributes;
    for (name in ref) {
      config = ref[name];
      if (config.remoteName === remoteName) {
        return name;
      }
    }
    return remoteName;
  };

  Base.prototype.getAttrType = function(attrName) {
    if (this.constructor.attributes == null) {
      return null;
    }
    if (this.constructor.attributes[attrName] == null) {
      return null;
    }
    return this.constructor.attributes[attrName].type;
  };

  Base.prototype.assignAttr = function(attrName, val) {
    var attrType;
    attrType = this.getAttrType(attrName);
    if (val == null) {
      this[attrName] = null;
      return;
    }
    switch (attrType) {
      case "Date":
        val = new Date(Date.parse(val));
        break;
      case "Integer":
      case "Int":
        val = parseInt(val);
        break;
      case "Float":
        val = parseFloat(val);
        break;
      case "Boolean":
      case "Bool":
        val = Boolean(parseInt(val));
        break;
      case "Number":
        val = Number(val);
        break;
      case "String":
        val = String(val);
    }
    return this[attrName] = val;
  };

  Base.prototype.attributes = function() {
    var _, attribs, name, ref;
    attribs = {
      id: this.id
    };
    if (this.constructor.attributes == null) {
      return attribs;
    }
    ref = this.constructor.attributes;
    for (name in ref) {
      _ = ref[name];
      attribs[name] = this[name];
    }
    return attribs;
  };

  Base.prototype.isValid = function() {
    var config, j, len, meth, name, pvs, ref, ref1, ref2, validationName, validationSettings, validator;
    if (this.constructor.attributes == null) {
      return true;
    }
    this.errors = null;
    ref = this.constructor.attributes;
    for (name in ref) {
      config = ref[name];
      if (config.validations == null) {
        continue;
      }
      ref1 = config.validations;
      for (validationName in ref1) {
        validationSettings = ref1[validationName];
        if ((this.id != null) && validationSettings.on === "create") {
          continue;
        }
        if ((this.id == null) && validationSettings.on === "update") {
          continue;
        }
        if ((validationSettings["if"] != null) && !validationSettings["if"](this)) {
          continue;
        }
        validator = validationName.charAt(0).toUpperCase() + validationName.slice(1);
        if (App.Validators[validator] == null) {
          console.log("Warning! \"" + validator + "\" validator is not implemented!");
          continue;
        }
        pvs = this.__processedValidationSettings(validationSettings);
        App.Validators[validator].instance(this, name, pvs).validate();
      }
    }
    if (this.constructor.validate != null) {
      ref2 = this.constructor.validate;
      for (j = 0, len = ref2.length; j < len; j++) {
        meth = ref2[j];
        this[meth]();
      }
    }
    if (this.errors != null) {
      return false;
    } else {
      return true;
    }
  };

  Base.prototype.isInvalid = function() {
    return !this.isValid();
  };

  Base.prototype.isEmpty = function() {
    var name, ref, val;
    ref = this.attributes();
    for (name in ref) {
      val = ref[name];
      if (this[name] !== null) {
        return false;
      }
    }
    return true;
  };

  Base.prototype.addErrorMessage = function(message, opts) {
    if (opts == null) {
      opts = {};
    }
    if (this.errors == null) {
      this.errors = {};
    }
    if (this.errors[opts["for"]] == null) {
      this.errors[opts["for"]] = [];
    }
    return this.errors[opts["for"]].push(message);
  };

  Base.prototype.save = function() {
    var jqxhr;
    jqxhr = $.ajax({
      dataType: 'json',
      method: this.id != null ? "PUT" : "POST",
      url: this.__getResourceUrl(),
      data: this.serialize()
    });
    return new Promise((function(_this) {
      return function(resolve, reject) {
        jqxhr.fail(function(xhr) {
          return reject(xhr);
        });
        return jqxhr.done(function(data) {
          if (data.success) {
            resolve(data);
            return;
          }
          if (data.errors != null) {
            _this.__assignRemoteErrorMessages(data.errors);
          }
          return resolve(data);
        });
      };
    })(this));
  };

  Base.prototype.updateAttribute = function(attr) {
    var jqxhr;
    jqxhr = $.ajax({
      dataType: 'json',
      method: 'PUT',
      url: this.__getResourceUrl(),
      data: this.serialize(attr)
    });
    return new Promise((function(_this) {
      return function(resolve, reject) {
        jqxhr.fail(function(xhr) {
          return reject(xhr);
        });
        return jqxhr.done(function(data) {
          if (data.success) {
            resolve(data);
            return;
          }
          if (data.errors != null) {
            _this.__assignRemoteErrorMessages(data.errors);
          }
          return resolve(data);
        });
      };
    })(this));
  };

  Base.prototype.serialize = function(attr) {
    var _, attribs, hash, mainKey, remoteName;
    if (attr == null) {
      attr = null;
    }
    if (this.constructor.attributes == null) {
      return {};
    }
    hash = {};
    mainKey = this.constructor.getRemoteName().toLowerCase();
    hash[mainKey] = {};
    attribs = {};
    if (attr != null) {
      attribs[attr] = null;
    } else {
      attribs = this.constructor.attributes;
    }
    for (attr in attribs) {
      _ = attribs[attr];
      remoteName = this.getAttrRemoteName(attr);
      hash[mainKey][remoteName] = this[attr];
    }
    return hash;
  };

  Base.prototype.reload = function() {
    var findParams, j, len, param, ref;
    findParams = {
      id: this.id
    };
    ref = this.constructor.getResourcesUrlParams();
    for (j = 0, len = ref.length; j < len; j++) {
      param = ref[j];
      findParams[param] = this[param];
    }
    return this.constructor.find(findParams);
  };

  Base.prototype.changes = function() {
    var currentObj, name, ref, result, val;
    result = {};
    currentObj = App.IdentityMap.find(this.getIdentity(), this.id);
    ref = this.attributes();
    for (name in ref) {
      val = ref[name];
      if (val !== currentObj[name]) {
        if (val.constructor === Date && currentObj[name] - val === 0) {
          continue;
        }
        if (val !== currentObj[name]) {
          result[name] = {
            is: currentObj[name],
            was: val
          };
        }
      }
    }
    return result;
  };

  Base.prototype.applyChanges = function() {
    var name, ref, results, vals;
    ref = this.changes();
    results = [];
    for (name in ref) {
      vals = ref[name];
      results.push(this[name] = vals.is);
    }
    return results;
  };

  Base.prototype.toKey = function() {
    return (this.getIdentity().toLowerCase()) + "_" + this.id;
  };

  Base.prototype.get = function(action, data) {
    if (data == null) {
      data = {};
    }
    return this.__send("GET", action, data);
  };

  Base.prototype.post = function(action, data) {
    if (data == null) {
      data = {};
    }
    return this.__send("POST", action, data);
  };

  Base.prototype.put = function(action, data) {
    if (data == null) {
      data = {};
    }
    return this.__send("PUT", action, data);
  };

  Base.prototype["delete"] = function(action, data) {
    if (data == null) {
      data = {};
    }
    return this.__send("DELETE", action, data);
  };

  Base.prototype.__send = function(method, action, data) {
    var jqxhr, url;
    url = this.__getResourceUrl();
    if (action != null) {
      url = url + "/" + action;
    }
    jqxhr = $.ajax({
      dataType: 'json',
      method: method,
      url: url,
      data: data
    });
    return new Promise(function(resolve, reject) {
      jqxhr.fail(function(xhr) {
        return reject(xhr);
      });
      return jqxhr.done(function(data) {
        return resolve(data);
      });
    });
  };

  Base.prototype.__assignAttributes = function(data) {
    var attrName, key, results, val;
    results = [];
    for (key in data) {
      val = data[key];
      attrName = this.getAttrName(key);
      results.push(this.assignAttr(attrName, val));
    }
    return results;
  };

  Base.prototype.__initAttributes = function() {
    var config, name, ref, results;
    ref = this.constructor.attributes;
    results = [];
    for (name in ref) {
      config = ref[name];
      results.push(this[name] = null);
    }
    return results;
  };

  Base.prototype.__assignRemoteErrorMessages = function(remoteErrors) {
    var attr, error, errors, remoteName, results;
    results = [];
    for (remoteName in remoteErrors) {
      errors = remoteErrors[remoteName];
      attr = this.getAttrName(remoteName);
      results.push((function() {
        var j, len, results1;
        results1 = [];
        for (j = 0, len = errors.length; j < len; j++) {
          error = errors[j];
          results1.push(this.addErrorMessage(error, {
            "for": attr
          }));
        }
        return results1;
      }).call(this));
    }
    return results;
  };

  Base.prototype.__getResourceUrl = function() {
    var url;
    url = this.constructor.__getResourcesUrl({
      resource: this.resource,
      obj: this
    });
    if (this.id == null) {
      return url;
    }
    return url + "/" + this.id;
  };

  Base.prototype.__processedValidationSettings = function(validationSettings) {
    var confName, confVal, res;
    res = {};
    for (confName in validationSettings) {
      confVal = validationSettings[confName];
      if (typeof confVal === 'function') {
        res[confName] = confVal(this);
      } else {
        res[confName] = confVal;
      }
    }
    return res;
  };

  return Base;

})();

var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

App.Controllers.Base = (function(superClass) {
  extend(Base, superClass);

  function Base() {
    this.views = {};
    this.receivers = {};
    this.subController = null;
    this.superController = null;
    this.params = this.__fetchParams();
  }

  Base.prototype.setView = function(key, view) {
    return this.views[key] = view;
  };

  Base.prototype.getView = function(key) {
    return this.views[key];
  };

  Base.prototype.getViews = function() {
    return this.views;
  };

  Base.prototype.setSubController = function(cntrlr) {
    return this.subController = cntrlr;
  };

  Base.prototype.getSubController = function() {
    return this.subController;
  };

  Base.prototype.setSuperController = function(cntrlr) {
    return this.superController = cntrlr;
  };

  Base.prototype.getSuperController = function() {
    return this.superController;
  };

  Base.prototype.setResource = function(name) {
    return this.setScope(name);
  };

  Base.prototype.setScope = function(name) {
    return App.Env.scope = name;
  };

  Base.prototype.__fetchParams = function() {
    var arr, i, id, key, len, match, params, paramsArray, paramsString, splitUrl, val;
    params = {};
    match = /https?:\/\/.+\/\w+\/(\d+)/.exec(window.location.href);
    id = match != null ? match[1] : null;
    if (id != null) {
      params["id"] = parseInt(id);
    }
    splitUrl = window.location.href.split('?');
    if (splitUrl.length === 1) {
      return params;
    }
    paramsString = splitUrl[splitUrl.length - 1];
    paramsArray = App.Utils.Array.map(paramsString.split('&'), function(s) {
      return s.split('=');
    });
    for (i = 0, len = paramsArray.length; i < len; i++) {
      arr = paramsArray[i];
      key = decodeURIComponent(arr[0]);
      val = decodeURIComponent(arr[1]);
      if (val != null) {
        val = val.replace(/\+/g, " ");
      }
      params[key] = val;
    }
    return params;
  };

  return Base;

})(App.Mix(App.Mixins.Connectivity));

var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

App.Views.Base = (function(superClass) {
  extend(Base, superClass);

  function Base(opts) {
    if (opts == null) {
      opts = {};
    }
    this.views = {};
    this.intervals = {};
    this.receivers = {};
    this.controller = null;
    this.delegator = null;
    if (opts.controller != null) {
      this.setController(opts.controller);
    }
    if (opts.delegator != null) {
      this.setDelegator(opts.delegator);
    }
  }

  Base.prototype.setController = function(cntr) {
    return this.controller = cntr;
  };

  Base.prototype.getController = function() {
    return this.controller;
  };

  Base.prototype.setView = function(key, view) {
    return this.views[key] = view;
  };

  Base.prototype.getView = function(key) {
    return this.views[key];
  };

  Base.prototype.getViews = function() {
    return this.views;
  };

  Base.prototype.setDelegator = function(delegator) {
    return this.delegator = delegator;
  };

  Base.prototype.getDelegator = function(delegator) {
    return this.delegator;
  };

  return Base;

})(App.Mix(App.Mixins.Connectivity));

App.UI.Form = (function() {
  function Form(opts) {
    if (opts == null) {
      opts = {};
    }
    this.formId = opts.id;
    this.obj = opts["for"];
    this.initObj = (opts.initObj != null) && opts.initObj ? true : false;
    this.delegator = opts.delegator;
    this.callbackSuccess = opts.callbackSuccess;
    this.callbackFailure = opts.callbackFailure;
    this.callbackActive = opts.callbackActive;
    this.form = this._findForm();
    this.submit = this.form.find(':submit');
    this.submitVal = this.submit.val();
    this.locale = App.Env.loco.getLocale();
  }

  Form.prototype.getObj = function() {
    return this.obj;
  };

  Form.prototype.render = function() {
    if (this.initObj) {
      this._assignAttribs();
    } else {
      this.fill();
    }
    return this._handle();
  };

  Form.prototype.fill = function(attr) {
    var _, attributes, formEl, name, radioEl, remoteName, results, uniqInputTypes;
    if (attr == null) {
      attr = null;
    }
    if (this.obj == null) {
      return null;
    }
    if (this.obj.constructor.attributes == null) {
      return null;
    }
    attributes = {};
    if (attr != null) {
      attributes[attr] = null;
    } else {
      attributes = this.obj.constructor.attributes;
    }
    results = [];
    for (name in attributes) {
      _ = attributes[name];
      remoteName = this.obj.getAttrRemoteName(name);
      formEl = this.form.find("[data-attr=" + remoteName + "]").find("input,textarea,select");
      if (formEl.length === 1) {
        formEl.val(this.obj[name]);
        continue;
      }
      uniqInputTypes = App.Utils.Array.uniq(App.Utils.Array.map(formEl, function(e) {
        return $(e).attr('type');
      }));
      if (uniqInputTypes.length === 1 && uniqInputTypes[0] === 'radio') {
        radioEl = App.Utils.Collection.find(formEl, (function(_this) {
          return function(e) {
            return $(e).val() === String(_this.obj[name]);
          };
        })(this));
        if (radioEl != null) {
          $(radioEl).prop('checked', true);
          continue;
        }
      }
      if (formEl.first().attr("type") !== "hidden" && formEl.last().attr('type') !== "checkbox") {
        continue;
      }
      results.push(formEl.last().prop('checked', Boolean(this.obj[name])));
    }
    return results;
  };

  Form.prototype._findForm = function() {
    var objName;
    if (this.formId != null) {
      return $("#" + this.formId);
    }
    if (this.obj != null) {
      objName = this.obj.getIdentity().toLowerCase();
      if (this.obj.id != null) {
        return $("#edit_" + objName + "_" + this.obj.id);
      } else {
        return $("#new_" + objName);
      }
    }
  };

  Form.prototype._handle = function() {
    return this.form.on('submit', (function(_this) {
      return function(e) {
        var clearForm;
        e.preventDefault();
        if (!_this._canBeSubmitted()) {
          return;
        }
        if (_this.obj == null) {
          _this._submitForm();
          return;
        }
        _this._assignAttribs();
        _this._hideErrors();
        if (_this.obj.isInvalid()) {
          _this._renderErrors();
          if (_this.callbackFailure != null) {
            _this.delegator[_this.callbackFailure]();
          }
          return;
        }
        _this._submittingForm(false);
        clearForm = _this.obj.id != null ? false : true;
        return _this.obj.save().then(function(data) {
          _this._alwaysAfterRequest();
          if (data.success) {
            return _this._handleSuccess(data, clearForm);
          } else {
            if (_this.callbackFailure != null) {
              _this.delegator[_this.callbackFailure]();
            }
            return _this._renderErrors();
          }
        })["catch"](function(err) {
          return _this._connectionError();
        });
      };
    })(this));
  };

  Form.prototype._canBeSubmitted = function() {
    if (this.submit.hasClass('active')) {
      return false;
    }
    if (this.submit.hasClass('success')) {
      return false;
    }
    if (this.submit.hasClass('failure')) {
      return false;
    }
    return true;
  };

  Form.prototype._submitForm = function() {
    var jqxhr, url;
    this._submittingForm();
    url = this.form.attr('action') + '.json';
    jqxhr = $.post(url, this.form.serialize());
    jqxhr.always((function(_this) {
      return function() {
        _this._alwaysAfterRequest();
        return _this.submit.blur();
      };
    })(this));
    jqxhr.fail((function(_this) {
      return function() {
        return _this._connectionError();
      };
    })(this));
    return jqxhr.done((function(_this) {
      return function(data) {
        if (data.success) {
          return _this._handleSuccess(data, _this.form.attr("method") === "POST");
        } else {
          return _this._renderErrors(data.errors);
        }
      };
    })(this));
  };

  Form.prototype._handleSuccess = function(data, clearForm) {
    var ref, ref1, val;
    if (clearForm == null) {
      clearForm = true;
    }
    val = (ref = (ref1 = data.flash) != null ? ref1.success : void 0) != null ? ref : App.I18n[this.locale].ui.form.success;
    this.submit.addClass('success').val(val);
    if (data.access_token != null) {
      App.Env.loco.getWire().setToken(data.access_token);
    }
    if (this.callbackSuccess != null) {
      if (data.data != null) {
        this.delegator[this.callbackSuccess](data.data);
      } else {
        this.delegator[this.callbackSuccess]();
      }
      return;
    }
    return setTimeout((function(_this) {
      return function() {
        var selector;
        _this.submit.removeAttr('disabled').removeClass('success').val(_this.submitVal);
        selector = ":not([data-loco-not-clear=true])";
        if (clearForm) {
          return _this.form.find("input:not([type='submit'])" + selector + ", textarea" + selector).val('');
        }
      };
    })(this), 5000);
  };

  Form.prototype._renderErrors = function(remoteErrors) {
    var attrib, data, errors, remoteName;
    if (remoteErrors == null) {
      remoteErrors = null;
    }
    if ((this.obj != null) && (this.obj.errors == null)) {
      return;
    }
    if ((this.obj == null) && (remoteErrors == null)) {
      return;
    }
    data = remoteErrors != null ? remoteErrors : this.obj.errors;
    for (attrib in data) {
      errors = data[attrib];
      remoteName = this.obj != null ? this.obj.getAttrRemoteName(attrib) : attrib;
      if ((remoteName != null) && attrib !== "base") {
        this.form.find("[data-attr=" + remoteName + "]").find(".errors[data-for=" + remoteName + "]").text(errors[0]);
        continue;
      }
      if (attrib === "base" && errors.length > 0) {
        if ($(".errors[data-for='base']").length === 1) {
          $(".errors[data-for='base']").text(errors[0]);
        } else {
          this.submit.val(errors[0]);
        }
      }
    }
    if (this.submit.val() === this.submitVal || this.submit.val() === App.I18n[this.locale].ui.form.sending) {
      this.submit.val(App.I18n[this.locale].ui.form.errors.invalid_data);
    }
    this.submit.addClass('failure');
    this._showErrors();
    return setTimeout((function(_this) {
      return function() {
        _this.submit.removeAttr('disabled').removeClass('failure').val(_this.submitVal);
        return _this.form.find('input.invalid, textarea.invalid, select.invalid').removeClass('invalid');
      };
    })(this), 1000);
  };

  Form.prototype._assignAttribs = function() {
    var _, formEl, name, radioEl, ref, remoteName, results, uniqInputTypes;
    if (this.obj.constructor.attributes == null) {
      return null;
    }
    ref = this.obj.constructor.attributes;
    results = [];
    for (name in ref) {
      _ = ref[name];
      remoteName = this.obj.getAttrRemoteName(name);
      formEl = this.form.find("[data-attr=" + remoteName + "]").find("input,textarea,select");
      if (formEl.length === 1) {
        this.obj.assignAttr(name, formEl.val());
        continue;
      }
      uniqInputTypes = App.Utils.Array.uniq(App.Utils.Array.map(formEl, function(e) {
        return $(e).attr('type');
      }));
      if (uniqInputTypes.length === 1 && uniqInputTypes[0] === 'radio') {
        radioEl = App.Utils.Collection.find(formEl, (function(_this) {
          return function(e) {
            return $(e).is(':checked');
          };
        })(this));
        if (radioEl != null) {
          this.obj.assignAttr(name, $(radioEl).val());
          continue;
        }
      }
      if (formEl.first().attr("type") !== "hidden" && formEl.last().attr('type') !== "checkbox") {
        continue;
      }
      if (formEl.last().is(":checked")) {
        results.push(this.obj.assignAttr(name, formEl.last().val()));
      } else {
        results.push(this.obj.assignAttr(name, formEl.first().val()));
      }
    }
    return results;
  };

  Form.prototype._hideErrors = function() {
    return this.form.find('.errors').each((function(_this) {
      return function(index, e) {
        if ($(e).text().trim().length > 0) {
          $(e).text("");
          return $(e).hide();
        }
      };
    })(this));
  };

  Form.prototype._showErrors = function() {
    return this.form.find('.errors').each((function(_this) {
      return function(index, e) {
        if ($(e).text().trim().length > 0) {
          return $(e).show();
        }
      };
    })(this));
  };

  Form.prototype._submittingForm = function(hideErrors) {
    if (hideErrors == null) {
      hideErrors = true;
    }
    this.submit.removeClass('success').removeClass('failure').addClass('active').val(App.I18n[this.locale].ui.form.sending);
    if (this.callbackActive != null) {
      this.delegator[this.callbackActive]();
    }
    if (hideErrors) {
      return this._hideErrors();
    }
  };

  Form.prototype._connectionError = function() {
    this.submit.removeClass('active').addClass('failure').val(App.I18n[this.locale].ui.form.errors.connection);
    return setTimeout((function(_this) {
      return function() {
        return _this.submit.removeAttr('disabled').removeClass('failure').val(_this.submitVal);
      };
    })(this), 3000);
  };

  Form.prototype._alwaysAfterRequest = function() {
    return this.submit.removeClass("active");
  };

  return Form;

})();

App.UI.Tabs = (function() {
  function Tabs(node, delegator, opts) {
    var ref;
    if (opts == null) {
      opts = {};
    }
    this.sel = $(node);
    this.delegator = delegator;
    this.animFunc = (ref = opts.animFunc) != null ? ref : 'animate';
    this.handle();
  }

  Tabs.prototype.handle = function() {
    var elementsSize;
    elementsSize = this.sel.find('a').size();
    return this.sel.find('a').click((function(_this) {
      return function(e) {
        var child, i, index, left, len, ref, width;
        e.preventDefault();
        if ($(e.target).hasClass("active")) {
          return;
        }
        index = 0;
        ref = $(e.target).parent().children('a');
        for (i = 0, len = ref.length; i < len; i++) {
          child = ref[i];
          if ($(child).text() === $(e.target).text()) {
            break;
          }
          index += 1;
        }
        width = parseInt(_this.sel.css('width'));
        left = width / elementsSize * index;
        _this.sel.find('a.active').removeClass('active');
        $(e.target).addClass('active');
        _this.sel.find('div.background')[_this.animFunc]({
          left: left
        }, 200);
        return _this.delegator[$(e.target).data("action")]();
      };
    })(this));
  };

  return Tabs;

})();

App.Services.Date = (function() {
  function Date(date) {
    this.date = date;
  }

  Date.prototype.toString = function(format) {
    var skope;
    if (format == null) {
      format = 'default';
    }
    skope = App.I18n[App.Env.loco.getLocale()].date.formats;
    switch (format) {
      case 'default':
        return this.strftime(skope["default"]);
      case 'short':
        return this.strftime(skope.short);
      case 'long':
        return this.strftime(skope.long);
      default:
        return console.log('App.Services.Date#toString: unknown format.');
    }
  };

  Date.prototype.strftime = function(str) {
    var skope;
    skope = App.I18n[App.Env.loco.getLocale()];
    str = str.replace('%Y', (function(_this) {
      return function(x) {
        return _this.date.getFullYear();
      };
    })(this));
    str = str.replace('%y', (function(_this) {
      return function(x) {
        return _this.date.getFullYear().toString().slice(-2);
      };
    })(this));
    str = str.replace('%m', (function(_this) {
      return function(x) {
        var month;
        month = _this.date.getMonth() + 1;
        if (month >= 10) {
          return month;
        } else {
          return "0" + month;
        }
      };
    })(this));
    str = str.replace('%b', (function(_this) {
      return function(x) {
        return skope.date.abbr_month_names[_this.date.getMonth()];
      };
    })(this));
    str = str.replace('%B', (function(_this) {
      return function(x) {
        return skope.date.month_names[_this.date.getMonth()];
      };
    })(this));
    str = str.replace('%d', (function(_this) {
      return function(x) {
        if (_this.date.getDate() >= 10) {
          return _this.date.getDate();
        } else {
          return "0" + (_this.date.getDate());
        }
      };
    })(this));
    str = str.replace('%H', (function(_this) {
      return function(x) {
        if (_this.date.getHours() >= 10) {
          return _this.date.getHours();
        } else {
          return "0" + (_this.date.getHours());
        }
      };
    })(this));
    return str = str.replace('%M', (function(_this) {
      return function(x) {
        if (_this.date.getMinutes() >= 10) {
          return _this.date.getMinutes();
        } else {
          return "0" + (_this.date.getMinutes());
        }
      };
    })(this));
  };

  return Date;

})();

App.Helpers.Text = (function() {
  function Text(opts) {
    if (opts == null) {
      opts = {};
    }
  }

  Text.prototype.simpleFormat = function(str) {
    str = str.replace(/\r\n?/, "\n");
    str = $.trim(str);
    if (str.length > 0) {
      str = str.replace(/\n\n+/g, '</p><p>');
      str = str.replace(/\n/g, '<br>');
      str = '<p>' + str + '</p>';
    }
    return str;
  };

  return Text;

})();

App.I18n.en = {
  variants: {},
  models: {},
  attributes: {},
  ui: {
    form: {
      sending: "Sending...",
      success: "Success",
      errors: {
        connection: "Connection Error",
        invalid_data: "Invalid data"
      }
    }
  },
  date: {
    formats: {
      "default": "%Y-%m-%d",
      short: "%b %d",
      long: "%B %d, %Y"
    },
    day_names: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
    abbr_day_names: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
    month_names: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
    abbr_month_names: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
  },
  errors: {
    messages: {
      accepted: "must be accepted",
      blank: "can't be blank",
      confirmation: "doesn't match %{attribute}",
      empty: "can't be empty",
      equal_to: "must be equal to %{count}",
      even: "must be even",
      exclusion: "is reserved",
      greater_than: "must be greater than %{count}",
      greater_than_or_equal_to: "must be greater than or equal to %{count}",
      inclusion: "is not included in the list",
      invalid: "is invalid",
      less_than: "must be less than %{count}",
      less_than_or_equal_to: "must be less than or equal to %{count}",
      not_a_number: "is not a number",
      not_an_integer: "must be an integer",
      odd: "must be odd",
      present: "must be blank",
      too_long: {
        one: "is too long (maximum is 1 character)",
        other: "is too long (maximum is %{count} characters)"
      },
      too_short: {
        one: "is too short (minimum is 1 character)",
        other: "is too short (minimum is %{count} characters)"
      },
      wrong_length: {
        one: "is the wrong length (should be 1 character)",
        other: "is the wrong length (should be %{count} characters)"
      },
      other_than: "must be other than %{count}"
    }
  }
};