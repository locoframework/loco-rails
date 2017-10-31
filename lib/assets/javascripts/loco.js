window.App = {
  Loco: null,
  IdentityMap: LocoModel.IdentityMap,
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
  Models: {
    Base: LocoModel.Base
  },
  Views: {},
  Services: {},
  Helpers: {},
  Presenters: {},
  Validators: LocoModel.Validators,
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
    this.uuid = null;
    this.delayedDisconnection = false;
  }

  Wire.prototype.setToken = function(token) {
    return this.token = token;
  };

  Wire.prototype.getSyncTime = function() {
    return this.syncTime;
  };

  Wire.prototype.setSyncTime = function(val) {
    return this.syncTime = val;
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

  Wire.prototype.getUuid = function() {
    return this.uuid;
  };

  Wire.prototype.setUuid = function(val) {
    return this.uuid = val;
  };

  Wire.prototype.setDelayedDisconnection = function() {
    return this.delayedDisconnection = true;
  };

  Wire.prototype.connect = function() {
    var line;
    line = App.Env.loco.getLine();
    if ((line != null) && !line.isWireAllowed()) {
      return;
    }
    return this.pollingInterval = setInterval((function(_this) {
      return function() {
        _this.check();
        if (_this.delayedDisconnection) {
          _this.delayedDisconnection = false;
          return _this.disconnect();
        }
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

  Wire.prototype.check = function() {
    var request;
    if (Object.keys(App.IdentityMap.imap).length === 0 && (this.token == null) && (this.syncTime != null)) {
      return;
    }
    request = new XMLHttpRequest();
    request.open('GET', this._getURL() + '?' + App.Utils.Object.toURIParams(this._requestParams()));
    request.onload = (function(_this) {
      return function(e) {
        var data, i, len, notification, notifications;
        if (e.target.status >= 200 && e.target.status < 400) {
          data = JSON.parse(e.target.response);
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
            return _this.check();
          }
        } else if (e.target.status >= 500) {
          return _this._handleDisconnection();
        }
      };
    })(this);
    request.onerror = (function(_this) {
      return function() {
        return _this._handleDisconnection();
      };
    })(this);
    return request.send();
  };

  Wire.prototype.fetchSyncTime = function(opts) {
    var request;
    if (opts == null) {
      opts = {};
    }
    request = new XMLHttpRequest();
    request.open('GET', (this._getURL()) + "/sync-time");
    request.onerror = (function(_this) {
      return function() {
        if (opts.after != null) {
          return _this[opts.after]();
        }
      };
    })(this);
    request.onload = (function(_this) {
      return function(e) {
        var data;
        if (e.target.status >= 200 && e.target.status < 400) {
          data = JSON.parse(e.target.response);
          _this.syncTime = data.sync_time;
          if (opts.after != null) {
            return _this[opts.after]();
          }
        } else if (e.target.status >= 500) {
          if (opts.after != null) {
            return _this[opts.after]();
          }
        }
      };
    })(this);
    return request.send();
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
      params.token = this.token;
    }
    if (this.uuid != null) {
      params.uuid = this.uuid;
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
    this.connected = false;
  }

  Line.prototype.connect = function() {
    return App.Channels.Loco.NotificationCenter = App.cable.subscriptions.create({
      channel: "Loco::NotificationCenterChannel"
    }, {
      connected: (function(_this) {
        return function() {
          var wire;
          console.log('ws connected');
          _this.connected = true;
          wire = App.Env.loco.getWire();
          if (wire != null) {
            wire.setDelayedDisconnection();
          }
          return _this._sendNotification({
            loco: 'connected'
          });
        };
      })(this),
      disconnected: (function(_this) {
        return function() {
          var wire;
          console.log('ws disconnected');
          _this.connected = false;
          wire = App.Env.loco.getWire();
          if (wire != null) {
            wire.setUuid(null);
            wire.fetchSyncTime({
              after: 'connect'
            });
          }
          return _this._sendNotification({
            loco: 'disconnected'
          });
        };
      })(this),
      rejected: (function(_this) {
        return function() {
          console.log('ws rejected');
          return _this._sendNotification({
            loco: 'rejected'
          });
        };
      })(this),
      received: (function(_this) {
        return function(data) {
          if (data.loco != null) {
            _this._processSystemNotification(data.loco);
            delete data.loco;
          }
          if (Object.keys(data).length === 0) {
            return;
          }
          return _this._sendNotification(data);
        };
      })(this)
    });
  };

  Line.prototype.isWireAllowed = function() {
    return !this.connected;
  };

  Line.prototype.send = function(data) {
    return App.Channels.Loco.NotificationCenter.send(data);
  };

  Line.prototype._processSystemNotification = function(data) {
    var wire;
    if (data.connection_check != null) {
      this.send({
        loco: {
          connection_check: true
        }
      });
    }
    wire = App.Env.loco.getWire();
    if (wire == null) {
      return;
    }
    if (data.sync_time != null) {
      wire.setSyncTime(data.sync_time);
    }
    if (data.uuid != null) {
      console.log("uuid: " + data.uuid);
      wire.setUuid(data.uuid);
    }
    if (data.notification != null) {
      wire.processNotification(data.notification);
    }
    if (data.xhr_notifications != null) {
      wire.check();
    }
    if (data.start_ajax_polling) {
      console.log("wire connected");
      this.connected = null;
      wire.setUuid(null);
      return wire.fetchSyncTime({
        after: 'connect'
      });
    }
  };

  Line.prototype._sendNotification = function(data) {
    var notificationCenter;
    notificationCenter = new App.Services.NotificationCenter;
    return notificationCenter.receivedSignal(data);
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
    this.startWire = ((ref1 = opts.notifications) != null ? ref1.enable : void 0) ? true : false;
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

  Loco.prototype.getLine = function() {
    return this.line;
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
    this.initWire();
    this.initLine();
    if (this.turbolinks) {
      event = Number(this.turbolinks) >= 5 ? "turbolinks:load" : "page:change";
      return document.addEventListener(event, (function(_this) {
        return function() {
          _this.flow();
          if (_this.postInit != null) {
            return _this.postInit();
          }
        };
      })(this));
    } else {
      return this.ready((function(_this) {
        return function() {
          _this.flow();
          if (_this.postInit != null) {
            return _this.postInit();
          }
        };
      })(this));
    }
  };

  Loco.prototype.ready = function(fn) {
    var cond;
    cond = document.attachEvent ? document.readyState === "complete" : document.readyState !== "loading";
    if (cond) {
      return fn();
    } else {
      return document.addEventListener('DOMContentLoaded', fn);
    }
  };

  Loco.prototype.initWire = function() {
    if (!this.startWire) {
      return;
    }
    this.wire = new App.Wire(this.notificationsParams);
    return this.wire.fetchSyncTime({
      after: 'connect'
    });
  };

  Loco.prototype.initLine = function() {
    if (App.cable == null) {
      return;
    }
    this.line = new App.Line;
    return this.line.connect();
  };

  Loco.prototype.flow = function() {
    var action_name, controller_name, namespace_name;
    App.IdentityMap.clear();
    namespace_name = document.getElementsByTagName('body')[0].getAttribute('data-namespace');
    controller_name = document.getElementsByTagName('body')[0].getAttribute('data-controller');
    action_name = document.getElementsByTagName('body')[0].getAttribute('data-action');
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
      return this.wire.fetchSyncTime();
    }
  };

  Loco.prototype.emit = function(data) {
    return this.line.send(data);
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
    var i, identity, len, resource, results;
    if (opts == null) {
      opts = {};
    }
    if (data == null) {
      return null;
    }
    if (data.constructor.name !== "Array") {
      data = [data];
    }
    data = App.Utils.Array.uniq(data);
    results = [];
    for (i = 0, len = data.length; i < len; i++) {
      resource = data[i];
      if (resource.constructor.name === "Function") {
        identity = resource.getIdentity();
        App.IdentityMap.addCollection(identity, {
          to: this
        });
        if (opts.receiver != null) {
          results.push(this.receivers[identity] = opts.receiver);
        } else {
          results.push(void 0);
        }
      } else {
        App.IdentityMap.connect(this, {
          "with": resource
        });
        if (opts.receiver != null) {
          results.push(this.receivers[resource.toKey()] = opts.receiver);
        } else {
          results.push(void 0);
        }
      }
    }
    return results;
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

App.Utils.Dom = (function() {
  function Dom() {}

  Dom.hasClass = function(el, className) {
    if (el.classList) {
      return el.classList.contains(className);
    } else {
      return new RegExp('(^| )' + className + '( |$)', 'gi').test(el.className);
    }
  };

  Dom.addClass = function(el, className) {
    if (el.classList) {
      return el.classList.add(className);
    } else {
      return el.className += ' ' + className;
    }
  };

  Dom.removeClass = function(el, className) {
    if (el.classList) {
      return el.classList.remove(className);
    } else {
      return el.className = el.className.replace(new RegExp('(^|\\b)' + className.split(' ').join('|') + '(\\b|$)', 'gi'), ' ');
    }
  };

  return Dom;

})();

App.Utils.Object = (function() {
  function Object() {}

  Object.toURIParams = function(obj) {
    var key, str, val;
    str = "";
    for (key in obj) {
      val = obj[key];
      if (str !== "") {
        str += "&";
      }
      str += key + "=" + encodeURIComponent(val);
    }
    return str;
  };

  return Object;

})();

App.Utils.String = (function() {
  function String() {}

  String.last = function(s) {
    return s[s.length - 1];
  };

  return String;

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
    this.submit = null;
    this.submitVal = null;
    if (this.form != null) {
      this.submit = this.form.querySelector('[type="submit"]');
    }
    if (this.submit != null) {
      this.submitVal = this.submit.value;
    }
    this.locale = App.Env.loco.getLocale();
  }

  Form.prototype.getObj = function() {
    return this.obj;
  };

  Form.prototype.render = function() {
    if (this.initObj) {
      this._assignAttribs();
      return this._handle();
    } else if (this.form != null) {
      this.fill();
      return this._handle();
    }
  };

  Form.prototype.fill = function(attr) {
    var _, attributes, formEl, name, query, radioEl, remoteName, results, uniqInputTypes;
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
      query = this.form.querySelector("[data-attr=" + remoteName + "]");
      if (query === null) {
        continue;
      }
      formEl = query.querySelectorAll("input,textarea,select");
      if (formEl.length === 0) {
        continue;
      }
      if (formEl.length === 1) {
        formEl[0].value = this.obj[name];
        continue;
      }
      uniqInputTypes = App.Utils.Array.uniq(App.Utils.Array.map(formEl, function(e) {
        return e.getAttribute('type');
      }));
      if (uniqInputTypes.length === 1 && uniqInputTypes[0] === 'radio') {
        radioEl = App.Utils.Collection.find(formEl, (function(_this) {
          return function(e) {
            return e.value === String(_this.obj[name]);
          };
        })(this));
        if (radioEl != null) {
          radioEl.checked = true;
          continue;
        }
      }
      if (formEl[0].getAttribute("type") !== "hidden" && formEl[formEl.length - 1].getAttribute('type') !== "checkbox") {
        continue;
      }
      results.push(formEl[formEl.length - 1].checked = Boolean(this.obj[name]));
    }
    return results;
  };

  Form.prototype._findForm = function() {
    var objName;
    if (this.formId != null) {
      return document.getElementById("" + this.formId);
    }
    if (this.obj != null) {
      objName = this.obj.getIdentity().toLowerCase();
      if (this.obj.id != null) {
        return document.getElementById("edit_" + objName + "_" + this.obj.id);
      } else {
        return document.getElementById("new_" + objName);
      }
    }
  };

  Form.prototype._handle = function() {
    return this.form.addEventListener('submit', (function(_this) {
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
    if (this.submit == null) {
      return true;
    }
    if (App.Utils.Dom.hasClass(this.submit, 'active')) {
      return false;
    }
    if (App.Utils.Dom.hasClass(this.submit, 'success')) {
      return false;
    }
    if (App.Utils.Dom.hasClass(this.submit, 'failure')) {
      return false;
    }
    return true;
  };

  Form.prototype._submitForm = function() {
    var data, ref, req, url;
    this._submittingForm();
    url = this.form.getAttribute('action') + '.json';
    data = new FormData(this.form);
    req = new XMLHttpRequest();
    req.open('POST', url);
    req.setRequestHeader("X-CSRF-Token", (ref = document.querySelector("meta[name='csrf-token']")) != null ? ref.content : void 0);
    req.onload = (function(_this) {
      return function(e) {
        _this._alwaysAfterRequest();
        if (_this.submit != null) {
          _this.submit.blur();
        }
        if (e.target.status >= 200 && e.target.status < 400) {
          data = JSON.parse(e.target.response);
          if (data.success) {
            return _this._handleSuccess(data, _this.form.getAttribute("method") === "POST");
          } else {
            return _this._renderErrors(data.errors);
          }
        } else if (e.target.status >= 500) {
          return _this._connectionError();
        }
      };
    })(this);
    req.onerror = (function(_this) {
      return function() {
        _this._alwaysAfterRequest();
        if (_this.submit != null) {
          _this.submit.blur();
        }
        return _this._connectionError();
      };
    })(this);
    return req.send(data);
  };

  Form.prototype._handleSuccess = function(data, clearForm) {
    var ref, ref1, val;
    if (clearForm == null) {
      clearForm = true;
    }
    val = (ref = (ref1 = data.flash) != null ? ref1.success : void 0) != null ? ref : App.I18n[this.locale].ui.form.success;
    if (this.submit != null) {
      App.Utils.Dom.addClass(this.submit, 'success');
      this.submit.value = val;
    }
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
        var i, len, node, nodes, results, selector;
        if (_this.submit != null) {
          _this.submit.disabled = false;
          App.Utils.Dom.removeClass(_this.submit, 'success');
          _this.submit.value = _this.submitVal;
        }
        selector = ":not([data-loco-not-clear=true])";
        if (clearForm) {
          nodes = _this.form.querySelectorAll("input:not([type='submit'])" + selector + ", textarea" + selector);
          results = [];
          for (i = 0, len = nodes.length; i < len; i++) {
            node = nodes[i];
            results.push(node.value = '');
          }
          return results;
        }
      };
    })(this), 5000);
  };

  Form.prototype._renderErrors = function(remoteErrors) {
    var attrib, data, errors, i, len, node, nodes, query, remoteName;
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
        query = this.form.querySelector("[data-attr=" + remoteName + "]");
        if (query === null) {
          continue;
        }
        nodes = query.querySelectorAll(".errors[data-for=" + remoteName + "]");
        if (nodes.length === 0) {
          continue;
        }
        for (i = 0, len = nodes.length; i < len; i++) {
          node = nodes[i];
          node.textContent = errors[0];
        }
        continue;
      }
      if (attrib === "base" && errors.length > 0) {
        nodes = document.querySelectorAll(".errors[data-for='base']");
        if (nodes.length === 1) {
          nodes[0].textContent = errors[0];
        } else if (this.submit != null) {
          this.submit.value = errors[0];
        }
      }
    }
    if (this.submit != null) {
      if (this.submit.value === this.submitVal || this.submit.value === App.I18n[this.locale].ui.form.sending) {
        this.submit.value = App.I18n[this.locale].ui.form.errors.invalid_data;
      }
      App.Utils.Dom.addClass(this.submit, 'failure');
    }
    this._showErrors();
    return setTimeout((function(_this) {
      return function() {
        var j, len1, ref, results;
        if (_this.submit != null) {
          _this.submit.disabled = false;
          App.Utils.Dom.removeClass(_this.submit, 'failure');
          _this.submit.val = _this.submitVal;
        }
        ref = _this.form.querySelectorAll('input.invalid, textarea.invalid, select.invalid');
        results = [];
        for (j = 0, len1 = ref.length; j < len1; j++) {
          node = ref[j];
          results.push(App.Utils.Dom.removeClass(node, 'invalid'));
        }
        return results;
      };
    })(this), 1000);
  };

  Form.prototype._assignAttribs = function() {
    var _, formEl, name, query, radioEl, ref, remoteName, results, uniqInputTypes;
    if (this.obj.constructor.attributes == null) {
      return null;
    }
    ref = this.obj.constructor.attributes;
    results = [];
    for (name in ref) {
      _ = ref[name];
      remoteName = this.obj.getAttrRemoteName(name);
      query = this.form.querySelector("[data-attr=" + remoteName + "]");
      if (query === null) {
        continue;
      }
      formEl = query.querySelectorAll("input,textarea,select");
      if (formEl.length === 0) {
        continue;
      }
      if (formEl.length === 1) {
        this.obj.assignAttr(name, formEl[0].value);
        continue;
      }
      uniqInputTypes = App.Utils.Array.uniq(App.Utils.Array.map(formEl, function(e) {
        return e.getAttribute('type');
      }));
      if (uniqInputTypes.length === 1 && uniqInputTypes[0] === 'radio') {
        radioEl = App.Utils.Collection.find(formEl, (function(_this) {
          return function(e) {
            return e.checked === true;
          };
        })(this));
        if (radioEl != null) {
          this.obj.assignAttr(name, radioEl.value);
          continue;
        }
      }
      if (formEl[0].getAttribute("type") !== "hidden" && formEl[formEl.length - 1].getAttribute('type') !== "checkbox") {
        continue;
      }
      if (formEl[formEl.length - 1].checked === true) {
        results.push(this.obj.assignAttr(name, formEl[formEl.length - 1].value));
      } else {
        results.push(this.obj.assignAttr(name, formEl[0].value));
      }
    }
    return results;
  };

  Form.prototype._hideErrors = function() {
    var e, i, len, ref, results;
    ref = this.form.querySelectorAll('.errors');
    results = [];
    for (i = 0, len = ref.length; i < len; i++) {
      e = ref[i];
      if (e.textContent.trim().length > 0) {
        e.textContent = '';
        results.push(e.style.display = 'none');
      } else {
        results.push(void 0);
      }
    }
    return results;
  };

  Form.prototype._showErrors = function() {
    var e, i, len, ref, results;
    ref = this.form.querySelectorAll('.errors');
    results = [];
    for (i = 0, len = ref.length; i < len; i++) {
      e = ref[i];
      if (e.textContent.trim().length > 0) {
        results.push(e.style.display = 'block');
      } else {
        results.push(void 0);
      }
    }
    return results;
  };

  Form.prototype._submittingForm = function(hideErrors) {
    if (hideErrors == null) {
      hideErrors = true;
    }
    if (this.submit != null) {
      App.Utils.Dom.removeClass(this.submit, 'success');
      App.Utils.Dom.removeClass(this.submit, 'failure');
      App.Utils.Dom.addClass(this.submit, 'active');
      this.submit.value = App.I18n[this.locale].ui.form.sending;
    }
    if (this.callbackActive != null) {
      this.delegator[this.callbackActive]();
    }
    if (hideErrors) {
      return this._hideErrors();
    }
  };

  Form.prototype._connectionError = function() {
    if (this.submit == null) {
      return;
    }
    App.Utils.Dom.removeClass(this.submit, 'active');
    App.Utils.Dom.addClass(this.submit, 'failure');
    this.submit.val = App.I18n[this.locale].ui.form.errors.connection;
    return setTimeout((function(_this) {
      return function() {
        _this.submit.disabled = false;
        App.Utils.Dom.removeClass(_this.submit, 'failure');
        return _this.submit.val = _this.submitVal;
      };
    })(this), 3000);
  };

  Form.prototype._alwaysAfterRequest = function() {
    if (this.submit == null) {
      return;
    }
    return App.Utils.Dom.removeClass(this.submit, 'active');
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
    str = str.replace('%M', (function(_this) {
      return function(x) {
        if (_this.date.getMinutes() >= 10) {
          return _this.date.getMinutes();
        } else {
          return "0" + (_this.date.getMinutes());
        }
      };
    })(this));
    return str = str.replace('%S', (function(_this) {
      return function(x) {
        if (_this.date.getSeconds() >= 10) {
          return _this.date.getSeconds();
        } else {
          return "0" + (_this.date.getSeconds());
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
    str = str.trim();
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
