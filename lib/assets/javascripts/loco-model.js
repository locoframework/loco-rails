(function webpackUniversalModuleDefinition(root, factory) {
	if(typeof exports === 'object' && typeof module === 'object')
		module.exports = factory();
	else if(typeof define === 'function' && define.amd)
		define([], factory);
	else if(typeof exports === 'object')
		exports["LocoModel"] = factory();
	else
		root["LocoModel"] = factory();
})(this, function() {
return /******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, {
/******/ 				configurable: false,
/******/ 				enumerable: true,
/******/ 				get: getter
/******/ 			});
/******/ 		}
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = 6);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
Object.defineProperty(__webpack_exports__, "__esModule", { value: true });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "Base", function() { return Base; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__validators__ = __webpack_require__(3);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__validators___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_0__validators__);
var Base;



Base = (function() {
  Base.sharedInstances = {};

  Base.instance = function(obj, attr, opts) {
    var sharedInstance, validatorName;
    validatorName = this.identity;
    if (this.sharedInstances[validatorName] == null) {
      this.sharedInstances[validatorName] = new __WEBPACK_IMPORTED_MODULE_0__validators__["Validators"][validatorName];
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




/***/ }),
/* 1 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
var LocalEnv = {
  loco: {
    getLocale: function getLocale() {
      return 'en';
    },
    protocolWithHost: null
  },
  scope: null
};

var Env = function Env() {
  if (typeof App === 'undefined') {
    return LocalEnv;
  }
  return App.Env;
};

exports.Env = Env;

/***/ }),
/* 2 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.I18n = undefined;

var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

var _en = __webpack_require__(9);

var I18n = function I18n() {
  if (typeof App !== 'undefined') {
    return _extends({ en: _en.en }, App.I18n);
  }
  return { en: _en.en };
};

exports.I18n = I18n;

/***/ }),
/* 3 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.Validators = undefined;

var _absence = __webpack_require__(8);

var _confirmation = __webpack_require__(10);

var _exclusion = __webpack_require__(11);

var _format = __webpack_require__(12);

var _inclusion = __webpack_require__(13);

var _length = __webpack_require__(4);

var _numericality = __webpack_require__(14);

var _presence = __webpack_require__(15);

var _size = __webpack_require__(16);

var Validators = {
  Absence: _absence.Absence,
  Confirmation: _confirmation.Confirmation,
  Exclusion: _exclusion.Exclusion,
  Format: _format.Format,
  Inclusion: _inclusion.Inclusion,
  Length: _length.Length,
  Numericality: _numericality.Numericality,
  Presence: _presence.Presence,
  Size: _size.Size
};

exports.Validators = Validators;

/***/ }),
/* 4 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
Object.defineProperty(__webpack_exports__, "__esModule", { value: true });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "Length", function() { return Length; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__base_coffee__ = __webpack_require__(0);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__i18n__ = __webpack_require__(2);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__i18n___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_1__i18n__);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__env__ = __webpack_require__(1);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__env___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_2__env__);
var Length,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;







Length = (function(superClass) {
  extend(Length, superClass);

  Length.identity = "Length";

  function Length() {
    Length.__super__.constructor.call(this);
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
      return Object(__WEBPACK_IMPORTED_MODULE_1__i18n__["I18n"])()[Object(__WEBPACK_IMPORTED_MODULE_2__env__["Env"])().loco.getLocale()].errors.messages[msg].one;
    }
    message = null;
    ref = ['few', 'many'];
    for (i = 0, len = ref.length; i < len; i++) {
      variant = ref[i];
      if (this._checkVariant(variant, val)) {
        message = Object(__WEBPACK_IMPORTED_MODULE_1__i18n__["I18n"])()[Object(__WEBPACK_IMPORTED_MODULE_2__env__["Env"])().loco.getLocale()].errors.messages[msg][variant];
        break;
      }
    }
    if (message == null) {
      message = Object(__WEBPACK_IMPORTED_MODULE_1__i18n__["I18n"])()[Object(__WEBPACK_IMPORTED_MODULE_2__env__["Env"])().loco.getLocale()].errors.messages[msg].other;
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
    if (Object(__WEBPACK_IMPORTED_MODULE_1__i18n__["I18n"])()[Object(__WEBPACK_IMPORTED_MODULE_2__env__["Env"])().loco.getLocale()].variants[variant] == null) {
      return;
    }
    return Object(__WEBPACK_IMPORTED_MODULE_1__i18n__["I18n"])()[Object(__WEBPACK_IMPORTED_MODULE_2__env__["Env"])().loco.getLocale()].variants[variant](val);
  };

  return Length;

})(__WEBPACK_IMPORTED_MODULE_0__base_coffee__["Base"]);




/***/ }),
/* 5 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
Object.defineProperty(__webpack_exports__, "__esModule", { value: true });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "IdentityMap", function() { return IdentityMap; });
var IdentityMap;

IdentityMap = (function() {
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




/***/ }),
/* 6 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.Validators = exports.IdentityMap = exports.Base = undefined;

var _base = __webpack_require__(7);

var _identity_map = __webpack_require__(5);

var _base2 = __webpack_require__(0);

var _validators = __webpack_require__(3);

_validators.Validators.Base = _base2.Base;

exports.Base = _base.Base;
exports.IdentityMap = _identity_map.IdentityMap;
exports.Validators = _validators.Validators;

/***/ }),
/* 7 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
Object.defineProperty(__webpack_exports__, "__esModule", { value: true });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "Base", function() { return Base; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__validators__ = __webpack_require__(3);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__validators___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_0__validators__);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__env__ = __webpack_require__(1);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__env___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_1__env__);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__utils__ = __webpack_require__(17);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__utils___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_2__utils__);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_3__identity_map_coffee__ = __webpack_require__(5);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_4__models__ = __webpack_require__(19);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_4__models___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_4__models__);
var Base;











Base = (function() {
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
    var id, req, urlParams;
    urlParams = {};
    if (typeof idOrObj === "object") {
      urlParams = idOrObj;
      id = idOrObj.id;
      delete urlParams.id;
    } else {
      id = idOrObj;
    }
    req = new XMLHttpRequest();
    req.open('GET', (this.__getResourcesUrl(urlParams)) + "/" + id);
    req.setRequestHeader("Accept", "application/json");
    req.setRequestHeader("Content-Type", "application/json");
    req.send(JSON.stringify(urlParams));
    return new Promise((function(_this) {
      return function(resolve, reject) {
        req.onerror = function(e) {
          return reject(e);
        };
        return req.onload = function(e) {
          var obj, record;
          record = JSON.parse(e.target.response);
          obj = _this.__initSubclass(record);
          __WEBPACK_IMPORTED_MODULE_3__identity_map_coffee__["IdentityMap"].add(obj);
          return resolve(obj);
        };
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
    resourcesUrl = this.resources == null ? "/" + (this.getRemoteName().toLowerCase()) + "s" : opts.resource ? this.resources[opts.resource].url : (Object(__WEBPACK_IMPORTED_MODULE_1__env__["Env"])().scope != null) && (this.resources[Object(__WEBPACK_IMPORTED_MODULE_1__env__["Env"])().scope] != null) ? this.resources[Object(__WEBPACK_IMPORTED_MODULE_1__env__["Env"])().scope].url : this.resources.url;
    if (Object(__WEBPACK_IMPORTED_MODULE_1__env__["Env"])().loco.protocolWithHost != null) {
      resourcesUrl = "" + (Object(__WEBPACK_IMPORTED_MODULE_1__env__["Env"])().loco.protocolWithHost) + resourcesUrl;
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
    var model, parts;
    if (params == null) {
      params = {};
    }
    parts = this.getIdentity().split(".");
    if (parts.length === 1) {
      model = Object(__WEBPACK_IMPORTED_MODULE_4__models__["Models"])()[parts[0]];
      if (model == null) {
        return new this(params);
      }
      return new model(params);
    }
    model = Object(__WEBPACK_IMPORTED_MODULE_4__models__["Models"])()[parts[0]][parts[1]];
    return new model(params);
  };

  Base.__page = function(i, opts, reqOpts, resp) {
    var data, httpMethod, key, ref, ref1, req, url, val;
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
    if (httpMethod === 'GET') {
      url = url + '?' + __WEBPACK_IMPORTED_MODULE_2__utils__["Utils"].Obj.toURIParams(data);
    }
    req = new XMLHttpRequest();
    req.open(httpMethod, url);
    req.setRequestHeader("Accept", "application/json");
    req.setRequestHeader("Content-Type", "application/json");
    req.setRequestHeader("X-CSRF-Token", (ref1 = document.querySelector("meta[name='csrf-token']")) != null ? ref1.content : void 0);
    req.send(JSON.stringify(data));
    return new Promise((function(_this) {
      return function(resolve, reject) {
        req.onerror = function(e) {
          return reject(e);
        };
        return req.onload = function(e) {
          var j, len, obj, record, ref2;
          data = JSON.parse(e.target.response);
          resp.count = data.count;
          for (key in data) {
            val = data[key];
            if (['resources', 'count'].indexOf(key) === -1) {
              resp[key] = val;
            }
          }
          ref2 = data.resources;
          for (j = 0, len = ref2.length; j < len; j++) {
            record = ref2[j];
            obj = _this.__initSubclass(record);
            if (opts.resource != null) {
              obj.resource = opts.resource;
            }
            __WEBPACK_IMPORTED_MODULE_3__identity_map_coffee__["IdentityMap"].add(obj);
            resp.resources.push(obj);
          }
          return resolve(resp);
        };
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
    if ((Object(__WEBPACK_IMPORTED_MODULE_1__env__["Env"])().scope != null) && (this.resources != null) && (this.resources[Object(__WEBPACK_IMPORTED_MODULE_1__env__["Env"])().scope] != null)) {
      param = (ref = this.resources[Object(__WEBPACK_IMPORTED_MODULE_1__env__["Env"])().scope]) != null ? (ref1 = ref.paginate) != null ? ref1.param : void 0 : void 0;
      return param != null ? param : defaultParam;
    }
    if (((ref2 = this.resources) != null ? (ref3 = ref2.paginate) != null ? ref3.param : void 0 : void 0) != null) {
      return this.resources.paginate.param;
    }
    return defaultParam;
  };

  Base.__getPaginationPer = function() {
    var ref, ref1, ref2, ref3;
    if ((Object(__WEBPACK_IMPORTED_MODULE_1__env__["Env"])().scope != null) && (this.resources != null) && (this.resources[Object(__WEBPACK_IMPORTED_MODULE_1__env__["Env"])().scope] != null)) {
      return (ref = this.resources[Object(__WEBPACK_IMPORTED_MODULE_1__env__["Env"])().scope]) != null ? (ref1 = ref.paginate) != null ? ref1.per : void 0 : void 0;
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
    return this.constructor.getIdentity();
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
        val = typeof val === 'boolean' ? val : Boolean(parseInt(val));
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
        if (__WEBPACK_IMPORTED_MODULE_0__validators__["Validators"][validator] == null) {
          console.log("Warning! \"" + validator + "\" validator is not implemented!");
          continue;
        }
        pvs = this.__processedValidationSettings(validationSettings);
        __WEBPACK_IMPORTED_MODULE_0__validators__["Validators"][validator].instance(this, name, pvs).validate();
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
    var httpMeth, ref, req;
    httpMeth = this.id != null ? "PUT" : "POST";
    req = new XMLHttpRequest();
    req.open(httpMeth, this.__getResourceUrl());
    req.setRequestHeader("Accept", "application/json");
    req.setRequestHeader("Content-Type", "application/json");
    req.setRequestHeader("X-CSRF-Token", (ref = document.querySelector("meta[name='csrf-token']")) != null ? ref.content : void 0);
    req.send(JSON.stringify(this.serialize()));
    return new Promise((function(_this) {
      return function(resolve, reject) {
        req.onerror = function(e) {
          return reject(e);
        };
        return req.onload = function(e) {
          var data;
          data = JSON.parse(e.target.response);
          if (data.success) {
            resolve(data);
            return;
          }
          if (data.errors != null) {
            _this.__assignRemoteErrorMessages(data.errors);
          }
          return resolve(data);
        };
      };
    })(this));
  };

  Base.prototype.updateAttribute = function(attr) {
    var ref, req;
    req = new XMLHttpRequest();
    req.open('PUT', this.__getResourceUrl());
    req.setRequestHeader("Accept", "application/json");
    req.setRequestHeader("Content-Type", "application/json");
    req.setRequestHeader("X-CSRF-Token", (ref = document.querySelector("meta[name='csrf-token']")) != null ? ref.content : void 0);
    req.send(JSON.stringify(this.serialize(attr)));
    return new Promise((function(_this) {
      return function(resolve, reject) {
        req.onerror = function(e) {
          return reject(e);
        };
        return req.onload = function(e) {
          var data;
          if (e.target.status >= 200 && e.target.status < 400) {
            data = JSON.parse(e.target.response);
            if (data.success) {
              resolve(data);
              return;
            }
            if (data.errors != null) {
              _this.__assignRemoteErrorMessages(data.errors);
            }
            return resolve(data);
          } else if (e.target.status >= 500) {
            return reject(e);
          }
        };
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
    currentObj = __WEBPACK_IMPORTED_MODULE_3__identity_map_coffee__["IdentityMap"].find(this.getIdentity(), this.id);
    ref = this.attributes();
    for (name in ref) {
      val = ref[name];
      if (val !== currentObj[name]) {
        if ((val != null) && val.constructor === Date && currentObj[name] - val === 0) {
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

  Base.prototype.patch = function(action, data) {
    if (data == null) {
      data = {};
    }
    return this.__send("PATCH", action, data);
  };

  Base.prototype["delete"] = function(action, data) {
    if (data == null) {
      data = {};
    }
    return this.__send("DELETE", action, data);
  };

  Base.prototype.__send = function(method, action, data) {
    var ref, req, url;
    url = this.__getResourceUrl();
    if (action != null) {
      url = url + "/" + action;
    }
    req = new XMLHttpRequest();
    req.open(method, url);
    req.setRequestHeader("Accept", "application/json");
    req.setRequestHeader("Content-Type", "application/json");
    req.setRequestHeader("X-CSRF-Token", (ref = document.querySelector("meta[name='csrf-token']")) != null ? ref.content : void 0);
    req.send(JSON.stringify(data));
    return new Promise(function(resolve, reject) {
      req.onerror = function(e) {
        return reject(e);
      };
      return req.onload = function(e) {
        if (e.target.status >= 200 && e.target.status < 400) {
          data = JSON.parse(e.target.response);
          return resolve(data);
        } else if (e.target.status >= 500) {
          return reject(e);
        }
      };
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




/***/ }),
/* 8 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
Object.defineProperty(__webpack_exports__, "__esModule", { value: true });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "Absence", function() { return Absence; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__base_coffee__ = __webpack_require__(0);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__i18n__ = __webpack_require__(2);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__i18n___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_1__i18n__);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__env__ = __webpack_require__(1);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__env___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_2__env__);
var Absence,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;







Absence = (function(superClass) {
  extend(Absence, superClass);

  Absence.identity = "Absence";

  function Absence() {
    Absence.__super__.constructor.call(this);
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
    message = this.opts.message != null ? this.opts.message : Object(__WEBPACK_IMPORTED_MODULE_1__i18n__["I18n"])()[Object(__WEBPACK_IMPORTED_MODULE_2__env__["Env"])().loco.getLocale()].errors.messages.present;
    return this.obj.addErrorMessage(message, {
      "for": this.attr
    });
  };

  return Absence;

})(__WEBPACK_IMPORTED_MODULE_0__base_coffee__["Base"]);




/***/ }),
/* 9 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
Object.defineProperty(__webpack_exports__, "__esModule", { value: true });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "en", function() { return en; });
var en;

en = {
  variants: {},
  models: {},
  attributes: {},
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




/***/ }),
/* 10 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
Object.defineProperty(__webpack_exports__, "__esModule", { value: true });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "Confirmation", function() { return Confirmation; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__base_coffee__ = __webpack_require__(0);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__i18n__ = __webpack_require__(2);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__i18n___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_1__i18n__);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__env__ = __webpack_require__(1);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__env___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_2__env__);
var Confirmation,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;







Confirmation = (function(superClass) {
  extend(Confirmation, superClass);

  Confirmation.identity = "Confirmation";

  function Confirmation() {
    Confirmation.__super__.constructor.call(this);
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
    attrNames = Object(__WEBPACK_IMPORTED_MODULE_1__i18n__["I18n"])()[Object(__WEBPACK_IMPORTED_MODULE_2__env__["Env"])().loco.getLocale()].attributes[this.obj.getIdentity()];
    attrName = (attrNames && attrNames[this.attr]) || defaultAttrName;
    message = this.opts.message != null ? this.opts.message : Object(__WEBPACK_IMPORTED_MODULE_1__i18n__["I18n"])()[Object(__WEBPACK_IMPORTED_MODULE_2__env__["Env"])().loco.getLocale()].errors.messages.confirmation;
    message = message.replace('%{attribute}', attrName);
    return this.obj.addErrorMessage(message, {
      "for": this._properAttr()
    });
  };

  Confirmation.prototype._properAttr = function() {
    return this.attr + "Confirmation";
  };

  return Confirmation;

})(__WEBPACK_IMPORTED_MODULE_0__base_coffee__["Base"]);




/***/ }),
/* 11 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
Object.defineProperty(__webpack_exports__, "__esModule", { value: true });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "Exclusion", function() { return Exclusion; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__base_coffee__ = __webpack_require__(0);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__i18n__ = __webpack_require__(2);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__i18n___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_1__i18n__);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__env__ = __webpack_require__(1);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__env___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_2__env__);
var Exclusion,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;







Exclusion = (function(superClass) {
  extend(Exclusion, superClass);

  Exclusion.identity = "Exclusion";

  function Exclusion() {
    Exclusion.__super__.constructor.call(this);
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
    message = this.opts.message != null ? this.opts.message : Object(__WEBPACK_IMPORTED_MODULE_1__i18n__["I18n"])()[Object(__WEBPACK_IMPORTED_MODULE_2__env__["Env"])().loco.getLocale()].errors.messages.exclusion;
    return this.obj.addErrorMessage(message, {
      "for": this.attr
    });
  };

  return Exclusion;

})(__WEBPACK_IMPORTED_MODULE_0__base_coffee__["Base"]);




/***/ }),
/* 12 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
Object.defineProperty(__webpack_exports__, "__esModule", { value: true });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "Format", function() { return Format; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__base_coffee__ = __webpack_require__(0);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__i18n__ = __webpack_require__(2);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__i18n___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_1__i18n__);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__env__ = __webpack_require__(1);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__env___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_2__env__);
var Format,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;







Format = (function(superClass) {
  extend(Format, superClass);

  Format.identity = "Format";

  function Format() {
    Format.__super__.constructor.call(this);
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
    message = this.opts.message != null ? this.opts.message : Object(__WEBPACK_IMPORTED_MODULE_1__i18n__["I18n"])()[Object(__WEBPACK_IMPORTED_MODULE_2__env__["Env"])().loco.getLocale()].errors.messages.invalid;
    return this.obj.addErrorMessage(message, {
      "for": this.attr
    });
  };

  return Format;

})(__WEBPACK_IMPORTED_MODULE_0__base_coffee__["Base"]);




/***/ }),
/* 13 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
Object.defineProperty(__webpack_exports__, "__esModule", { value: true });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "Inclusion", function() { return Inclusion; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__base_coffee__ = __webpack_require__(0);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__i18n__ = __webpack_require__(2);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__i18n___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_1__i18n__);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__env__ = __webpack_require__(1);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__env___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_2__env__);
var Inclusion,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;







Inclusion = (function(superClass) {
  extend(Inclusion, superClass);

  Inclusion.identity = "Inclusion";

  function Inclusion() {
    Inclusion.__super__.constructor.call(this);
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
    message = this.opts.message != null ? this.opts.message : Object(__WEBPACK_IMPORTED_MODULE_1__i18n__["I18n"])()[Object(__WEBPACK_IMPORTED_MODULE_2__env__["Env"])().loco.getLocale()].errors.messages.inclusion;
    return this.obj.addErrorMessage(message, {
      "for": this.attr
    });
  };

  return Inclusion;

})(__WEBPACK_IMPORTED_MODULE_0__base_coffee__["Base"]);




/***/ }),
/* 14 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
Object.defineProperty(__webpack_exports__, "__esModule", { value: true });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "Numericality", function() { return Numericality; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__base_coffee__ = __webpack_require__(0);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__i18n__ = __webpack_require__(2);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__i18n___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_1__i18n__);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__env__ = __webpack_require__(1);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__env___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_2__env__);
var Numericality,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;







Numericality = (function(superClass) {
  extend(Numericality, superClass);

  Numericality.identity = "Numericality";

  function Numericality() {
    Numericality.__super__.constructor.call(this);
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
    message = this.opts.message != null ? this.opts.message : Object(__WEBPACK_IMPORTED_MODULE_1__i18n__["I18n"])()[Object(__WEBPACK_IMPORTED_MODULE_2__env__["Env"])().loco.getLocale()].errors.messages.not_a_number;
    return this.obj.addErrorMessage(message, {
      "for": this.attr
    });
  };

  Numericality.prototype._addIntErrorMessage = function() {
    var message;
    message = Object(__WEBPACK_IMPORTED_MODULE_1__i18n__["I18n"])()[Object(__WEBPACK_IMPORTED_MODULE_2__env__["Env"])().loco.getLocale()].errors.messages.not_an_integer;
    return this.obj.addErrorMessage(message, {
      "for": this.attr
    });
  };

  Numericality.prototype._addGreatherThanErrorMessage = function() {
    var message;
    message = Object(__WEBPACK_IMPORTED_MODULE_1__i18n__["I18n"])()[Object(__WEBPACK_IMPORTED_MODULE_2__env__["Env"])().loco.getLocale()].errors.messages.greater_than;
    message = message.replace('%{count}', this.opts.greater_than);
    return this.obj.addErrorMessage(message, {
      "for": this.attr
    });
  };

  Numericality.prototype._addGreatherThanOrEqualToErrorMessage = function() {
    var message;
    message = Object(__WEBPACK_IMPORTED_MODULE_1__i18n__["I18n"])()[Object(__WEBPACK_IMPORTED_MODULE_2__env__["Env"])().loco.getLocale()].errors.messages.greater_than_or_equal_to;
    message = message.replace('%{count}', this.opts.greater_than_or_equal_to);
    return this.obj.addErrorMessage(message, {
      "for": this.attr
    });
  };

  Numericality.prototype._addEqualToErrorMessage = function() {
    var message;
    message = Object(__WEBPACK_IMPORTED_MODULE_1__i18n__["I18n"])()[Object(__WEBPACK_IMPORTED_MODULE_2__env__["Env"])().loco.getLocale()].errors.messages.equal_to;
    message = message.replace('%{count}', this.opts.equal_to);
    return this.obj.addErrorMessage(message, {
      "for": this.attr
    });
  };

  Numericality.prototype._addLessThanErrorMessage = function() {
    var message;
    message = Object(__WEBPACK_IMPORTED_MODULE_1__i18n__["I18n"])()[Object(__WEBPACK_IMPORTED_MODULE_2__env__["Env"])().loco.getLocale()].errors.messages.less_than;
    message = message.replace('%{count}', this.opts.less_than);
    return this.obj.addErrorMessage(message, {
      "for": this.attr
    });
  };

  Numericality.prototype._addLessThanOrEqualToErrorMessage = function() {
    var message;
    message = Object(__WEBPACK_IMPORTED_MODULE_1__i18n__["I18n"])()[Object(__WEBPACK_IMPORTED_MODULE_2__env__["Env"])().loco.getLocale()].errors.messages.less_than_or_equal_to;
    message = message.replace('%{count}', this.opts.less_than_or_equal_to);
    return this.obj.addErrorMessage(message, {
      "for": this.attr
    });
  };

  Numericality.prototype._addOtherThanErrorMessage = function() {
    var message;
    message = Object(__WEBPACK_IMPORTED_MODULE_1__i18n__["I18n"])()[Object(__WEBPACK_IMPORTED_MODULE_2__env__["Env"])().loco.getLocale()].errors.messages.other_than;
    message = message.replace('%{count}', this.opts.other_than);
    return this.obj.addErrorMessage(message, {
      "for": this.attr
    });
  };

  Numericality.prototype._addOddErrorMessage = function() {
    var message;
    message = Object(__WEBPACK_IMPORTED_MODULE_1__i18n__["I18n"])()[Object(__WEBPACK_IMPORTED_MODULE_2__env__["Env"])().loco.getLocale()].errors.messages.odd;
    return this.obj.addErrorMessage(message, {
      "for": this.attr
    });
  };

  Numericality.prototype._addEvenErrorMessage = function() {
    var message;
    message = Object(__WEBPACK_IMPORTED_MODULE_1__i18n__["I18n"])()[Object(__WEBPACK_IMPORTED_MODULE_2__env__["Env"])().loco.getLocale()].errors.messages.even;
    return this.obj.addErrorMessage(message, {
      "for": this.attr
    });
  };

  return Numericality;

})(__WEBPACK_IMPORTED_MODULE_0__base_coffee__["Base"]);




/***/ }),
/* 15 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
Object.defineProperty(__webpack_exports__, "__esModule", { value: true });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "Presence", function() { return Presence; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__base_coffee__ = __webpack_require__(0);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__i18n__ = __webpack_require__(2);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__i18n___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_1__i18n__);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__env__ = __webpack_require__(1);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__env___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_2__env__);
var Presence,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;







Presence = (function(superClass) {
  extend(Presence, superClass);

  Presence.identity = "Presence";

  function Presence() {
    Presence.__super__.constructor.call(this);
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
    message = this.opts.message != null ? this.opts.message : Object(__WEBPACK_IMPORTED_MODULE_1__i18n__["I18n"])()[Object(__WEBPACK_IMPORTED_MODULE_2__env__["Env"])().loco.getLocale()].errors.messages.blank;
    return this.obj.addErrorMessage(message, {
      "for": this.attr
    });
  };

  return Presence;

})(__WEBPACK_IMPORTED_MODULE_0__base_coffee__["Base"]);




/***/ }),
/* 16 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
Object.defineProperty(__webpack_exports__, "__esModule", { value: true });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "Size", function() { return Size; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__base_coffee__ = __webpack_require__(0);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__length_coffee__ = __webpack_require__(4);
var Size,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;





Size = (function(superClass) {
  extend(Size, superClass);

  Size.identity = "Size";

  function Size() {
    Size.__super__.constructor.call(this);
  }

  Size.prototype.validate = function() {
    return __WEBPACK_IMPORTED_MODULE_1__length_coffee__["Length"].instance(this.obj, this.attr, this.opts).validate();
  };

  return Size;

})(__WEBPACK_IMPORTED_MODULE_0__base_coffee__["Base"]);




/***/ }),
/* 17 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.Utils = undefined;

var _obj = __webpack_require__(18);

var Utils = {
  Obj: _obj.Obj
};

exports.Utils = Utils;

/***/ }),
/* 18 */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
Object.defineProperty(__webpack_exports__, "__esModule", { value: true });
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "Obj", function() { return Obj; });
var Obj;

Obj = (function() {
  function Obj() {}

  Obj.toURIParams = function(obj) {
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

  return Obj;

})();




/***/ }),
/* 19 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
var Models = function Models() {
  if (typeof App === 'undefined') {
    return {};
  }
  return App.Models;
};

exports.Models = Models;

/***/ })
/******/ ]);
});