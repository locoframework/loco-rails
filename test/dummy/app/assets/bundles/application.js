!function(e){function t(t){for(var n,a,c=t[0],u=t[1],l=t[2],p=0,f=[];p<c.length;p++)a=c[p],o[a]&&f.push(o[a][0]),o[a]=0;for(n in u)Object.prototype.hasOwnProperty.call(u,n)&&(e[n]=u[n]);for(s&&s(t);f.length;)f.shift()();return i.push.apply(i,l||[]),r()}function r(){for(var e,t=0;t<i.length;t++){for(var r=i[t],n=!0,c=1;c<r.length;c++){var u=r[c];0!==o[u]&&(n=!1)}n&&(i.splice(t--,1),e=a(a.s=r[0]))}return e}var n={},o={0:0},i=[];function a(t){if(n[t])return n[t].exports;var r=n[t]={i:t,l:!1,exports:{}};return e[t].call(r.exports,r,r.exports,a),r.l=!0,r.exports}a.m=e,a.c=n,a.d=function(e,t,r){a.o(e,t)||Object.defineProperty(e,t,{enumerable:!0,get:r})},a.r=function(e){"undefined"!=typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(e,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(e,"__esModule",{value:!0})},a.t=function(e,t){if(1&t&&(e=a(e)),8&t)return e;if(4&t&&"object"==typeof e&&e&&e.__esModule)return e;var r=Object.create(null);if(a.r(r),Object.defineProperty(r,"default",{enumerable:!0,value:e}),2&t&&"string"!=typeof e)for(var n in e)a.d(r,n,function(t){return e[t]}.bind(null,n));return r},a.n=function(e){var t=e&&e.__esModule?function(){return e.default}:function(){return e};return a.d(t,"a",t),t},a.o=function(e,t){return Object.prototype.hasOwnProperty.call(e,t)},a.p="";var c=window.webpackJsonp=window.webpackJsonp||[],u=c.push.bind(c);c.push=t,c=c.slice();for(var l=0;l<c.length;l++)t(c[l]);var s=u;i.push([129,1]),r()}({127:function(e,t,r){},128:function(e,t,r){},129:function(e,t,r){"use strict";r.r(t);r(61);var n=r(1),o=r(87);r.n(o).a.start();var i=r(88),a=r.n(i),c=function(){function e(){}return e.prototype.receivedSignal=function(e){switch(e.signal){case"ping":return this._pingSignal();case"message":return this._messageSignal(e)}},e.prototype._pingSignal=function(){if(n.Env.namespaceController.constructor===App.Controllers.User)return alert("Ping!")},e.prototype._messageSignal=function(e){var t;if(t=this._getRoomView())return t.receivedMessage(e.message,e.author)},e.prototype._getRoomView=function(){return n.Env.namespaceController.constructor===App.Controllers.User&&(n.Env.controller.constructor===App.Controllers.User.Rooms&&("show"===n.Env.action&&n.Env.controller.getView("show")))},e}(),u=(r(9),r(10),r(11),r(45),r(100),r(56),r(8),r(104),r(25),r(105),r(26),r(7),r(12),r(107),r(13),r(27));r(58),r(114),r(115),r(32);function l(e){return function(e){if(Array.isArray(e)){for(var t=0,r=new Array(e.length);t<e.length;t++)r[t]=e[t];return r}}(e)||function(e){if(Symbol.iterator in Object(e)||"[object Arguments]"===Object.prototype.toString.call(e))return Array.from(e)}(e)||function(){throw new TypeError("Invalid attempt to spread non-iterable instance")}()}var s=function(e,t){switch(t.type){case"SET":return{articles:l(t.payload.articles)};case"ADD":return{articles:[].concat(l(e.articles),l(t.payload.articles))};case"UPDATE":return{articles:[].concat(l(e.articles.slice(0,t.payload.index)),[t.payload.article],l(e.articles.slice(t.payload.index+1)))};default:return e}},p=function(e,t){var r=e.articles.find(function(e){return e.id===t});return r?[r,e.articles.indexOf(r)]:[null,null]},f=Object(u.b)(s,{articles:[]});function y(e){return function(e){if(Array.isArray(e)){for(var t=0,r=new Array(e.length);t<e.length;t++)r[t]=e[t];return r}}(e)||function(e){if(Symbol.iterator in Object(e)||"[object Arguments]"===Object.prototype.toString.call(e))return Array.from(e)}(e)||function(){throw new TypeError("Invalid attempt to spread non-iterable instance")}()}var d=function(){var e=arguments.length>0&&void 0!==arguments[0]?arguments[0]:[],t=arguments.length>1?arguments[1]:void 0;switch(t.type){case"PREPEND_ARTICLE":return[].concat(y(t.payload.articles),y(e));case"SET_ARTICLES":return y(t.payload.articles);default:return e}};function m(e){return function(e){if(Array.isArray(e)){for(var t=0,r=new Array(e.length);t<e.length;t++)r[t]=e[t];return r}}(e)||function(e){if(Symbol.iterator in Object(e)||"[object Arguments]"===Object.prototype.toString.call(e))return Array.from(e)}(e)||function(){throw new TypeError("Invalid attempt to spread non-iterable instance")}()}var h=function(){var e=arguments.length>0&&void 0!==arguments[0]?arguments[0]:[],t=arguments.length>1?arguments[1]:void 0;switch(t.type){case"APPEND_USER":return[].concat(m(e),m(t.payload.users));case"SET_USERS":return m(t.payload.users);case"PREPEND_USER":return[].concat(m(t.payload.users),m(e));default:return e}},b=Object(u.a)({articles:d,users:h}),v=Object(u.b)(b,{users:[],articles:[]}),_={}.hasOwnProperty,g=function(e){function t(e){t.__super__.constructor.call(this,e),this.published=null!=this.publishedAt}return function(e,t){for(var r in t)_.call(t,r)&&(e[r]=t[r]);function n(){this.constructor=e}n.prototype=t.prototype,e.prototype=new n,e.__super__=t.prototype}(t,n["Models"].Base),t.identity="Article",t.resources={url:"/user/articles",paginate:{per:5},main:{url:"/articles",paginate:{per:3}},admin:{url:"/admin/articles",paginate:{per:4}}},t.attributes={title:{validations:{presence:!0,length:{within:[3,255]}}},content:{validations:{presence:!0,length:{minimum:100}},remoteName:"text"},createdAt:{type:"Date",remoteName:"created_at"},updatedAt:{type:"Date",remoteName:"updated_at"},commentsCount:{type:"Int",remoteName:"comments_count"},publishedAt:{type:"Date",remoteName:"published_at"},published:{},adminReview:{remoteName:"admin_review"},adminRate:{type:"Int",remoteName:"admin_rate"},categoryId:{type:"Int",remoteName:"category_id"},adminReviewStartedAt:{remoteName:"admin_review_started_at"}},t.receivedSignal=function(e,t){},t.validate=["vulgarityLevel"],t.prototype.receivedSignal=function(e,t){},t.prototype.vulgarityLevel=function(){if(null!=this.title&&/fuck/i.exec(this.title)||null!=this.content&&/fuck/i.exec(this.content))return this.addErrorMessage("Article contains strong language.",{for:"base"})},t.prototype.setDefaultValuesForAdminReview=function(){return null==this.adminRate&&(this.adminRate=3),null==this.categoryId&&(this.categoryId=6),this.adminReviewStartedAt=Date.now()},t}(),w={}.hasOwnProperty,O=function(e){function t(e){t.__super__.constructor.call(this,e)}return function(e,t){for(var r in t)w.call(t,r)&&(e[r]=t[r]);function n(){this.constructor=e}n.prototype=t.prototype,e.prototype=new n,e.__super__=t.prototype}(t,n["Models"].Base),t.identity="Article.Comment",t.remoteName="Comment",t.resources={url:"/user/articles/:articleId/comments",paginate:{per:10},main:{url:"/articles/:articleId/comments",paginate:{per:5,param:"page-num"}},admin:{url:"/admin/articles/:articleId/comments",paginate:{per:5}}},t.attributes={author:{validations:{presence:!0}},text:{validations:{presence:!0,vulgarity:!0}},articleId:{type:"Int",validations:{presence:!0},remoteName:"article_id"},createdAt:{type:"Date",remoteName:"created_at"},updatedAt:{type:"Date",remoteName:"updated_at"},emotion:{type:"Int"},pinned:{type:"Boolean"},adminRate:{type:"Int",remoteName:"admin_rate"},approved:{type:"Boolean"}},t.receivedSignal=function(e,t){},t.prototype.receivedSignal=function(e,t){},t}(),E={}.hasOwnProperty,S=function(e){function t(e){t.__super__.constructor.call(this,e)}return function(e,t){for(var r in t)E.call(t,r)&&(e[r]=t[r]);function n(){this.constructor=e}n.prototype=t.prototype,e.prototype=new n,e.__super__=t.prototype}(t,n["Models"].Base),t.identity="User",t.resources={url:"/users",admin:{url:"/admin/users"}},t.paginate={per:10},t.attributes={email:{validations:{presence:!0,format:{with:/^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}}},username:{validations:{presence:!0,format:{with:/^[a-z][a-z0-9_\-]*$/i}}},password:{validations:{presence:{on:"create"},confirmation:!0}},passwordConfirmation:{remoteName:"password_confirmation"},confirmed:{},createdAt:{type:"Date",remoteName:"created_at"},updatedAt:{type:"Date",remoteName:"updated_at"}},t.receivedSignal=function(e,t){return console.log("App.Models.User.receivedSignal: "+e)},t.prototype.receivedSignal=function(e,t){return console.log("App.Models.User#receivedSignal: "+e)},t}(),j={}.hasOwnProperty,A=function(e){function t(e){var r,n,o,i;null==e&&(e={}),t.__super__.constructor.call(this,e),this.notice=null!=(r=e.notice)?r:null,this.alert=null!=(n=e.alert)?n:null,this.warning=null!=(o=e.warning)?o:null,this.hide=null==(i=e.hide)||i}return function(e,t){for(var r in t)j.call(t,r)&&(e[r]=t[r]);function n(){this.constructor=e}n.prototype=t.prototype,e.prototype=new n,e.__super__=t.prototype}(t,n["Views"].Base),t.prototype.setNotice=function(e){return this.notice=e},t.prototype.setAlert=function(e){return this.alert=e},t.prototype.setWarning=function(e){return this.warning=e},t.prototype.render=function(){var e;if((e=document.querySelector(".flash")).classList.remove("notice"),e.classList.remove("alert"),e.classList.remove("warning"),null!=this.notice?(e.classList.add("notice"),document.querySelector(".flash p").textContent=this.notice):null!=this.alert?(e.classList.add("alert"),document.querySelector(".flash p").textContent=this.alert):null!=this.warning&&(e.classList.add("warning"),document.querySelector(".flash p").textContent=this.warning),e.classList.remove("none"),this.hide)return this.hideAfterTime()},t.prototype.hideAfterTime=function(e){return null==e&&(e=4e3),setTimeout(function(){return document.querySelector(".flash").classList.add("none")},e)},t}(),P=function(){function e(){}return e.prototype.disconnectedForTooLong=function(e){return"You have been disconnected from the server for too long. Reload page!",new A({alert:"You have been disconnected from the server for too long. Reload page!",hide:!1}).render()},e}(),C=r(0),T=r.n(C),R=r(22),I=r(2),x=r.n(I);r(59);function k(e){var t=e.article,r=new n.Services.Date(t.publishedAt).toString("short");return T.a.createElement("article",{id:"article_".concat(t.id)},T.a.createElement("h2",null,t.title),T.a.createElement("p",null,T.a.createElement("i",null,t.author," wrote this on ",r," /"," ",T.a.createElement("span",{className:"comments_quantity"},t.commentsCount," comment",1===t.commentsCount?"":"s"))),T.a.createElement("p",null,t.content),T.a.createElement("p",null,T.a.createElement("a",{href:"/admin/articles/".concat(t.id,"/edit")},"Review")))}k.propTypes={article:x.a.instanceOf(g).isRequired};var D=k;function N(e){var t=e.articles.map(function(e){return T.a.createElement(D,{key:e.id,article:e})});return T.a.createElement(T.a.Fragment,null,t)}N.propTypes={articles:x.a.arrayOf(x.a.instanceOf(g)).isRequired};var B=N;function L(e,t){return function(e){if(Array.isArray(e))return e}(e)||function(e,t){var r=[],n=!0,o=!1,i=void 0;try{for(var a,c=e[Symbol.iterator]();!(n=(a=c.next()).done)&&(r.push(a.value),!t||r.length!==t);n=!0);}catch(e){o=!0,i=e}finally{try{n||null==c.return||c.return()}finally{if(o)throw i}}return r}(e,t)||function(){throw new TypeError("Invalid attempt to destructure non-iterable instance")}()}function U(e){var t=L(Object(C.useState)(e.articles),2),r=t[0],n=t[1];return Object(C.useEffect)(function(){var e=v.subscribe(function(){return n(v.getState().articles)});return function(){e()}}),T.a.createElement(B,{articles:r})}U.propTypes={articles:x.a.arrayOf(x.a.instanceOf(g)).isRequired};var q=U;function M(e){return(M="function"==typeof Symbol&&"symbol"==typeof Symbol.iterator?function(e){return typeof e}:function(e){return e&&"function"==typeof Symbol&&e.constructor===Symbol&&e!==Symbol.prototype?"symbol":typeof e})(e)}function V(e,t){for(var r=0;r<t.length;r++){var n=t[r];n.enumerable=n.enumerable||!1,n.configurable=!0,"value"in n&&(n.writable=!0),Object.defineProperty(e,n.key,n)}}function F(e,t){return!t||"object"!==M(t)&&"function"!=typeof t?function(e){if(void 0===e)throw new ReferenceError("this hasn't been initialised - super() hasn't been called");return e}(e):t}function z(e){return(z=Object.setPrototypeOf?Object.getPrototypeOf:function(e){return e.__proto__||Object.getPrototypeOf(e)})(e)}function W(e,t){return(W=Object.setPrototypeOf||function(e,t){return e.__proto__=t,e})(e,t)}var Y=function(e){function t(){var e=arguments.length>0&&void 0!==arguments[0]?arguments[0]:{};return function(e,t){if(!(e instanceof t))throw new TypeError("Cannot call a class as a function")}(this,t),F(this,z(t).call(this,e))}var r,o,i;return function(e,t){if("function"!=typeof t&&null!==t)throw new TypeError("Super expression must either be null or a function");e.prototype=Object.create(t&&t.prototype,{constructor:{value:e,writable:!0,configurable:!0}}),t&&W(e,t)}(t,n["Views"].Base),r=t,(o=[{key:"render",value:function(e){var t=e.articles;Object(R.render)(T.a.createElement(q,{articles:t}),document.getElementById("articles"))}}])&&V(r.prototype,o),i&&V(r,i),t}(),J={}.hasOwnProperty,Q=function(e){function t(){return t.__super__.constructor.apply(this,arguments)}return function(e,t){for(var r in t)J.call(t,r)&&(e[r]=t[r]);function n(){this.constructor=e}n.prototype=t.prototype,e.prototype=new n,e.__super__=t.prototype}(t,n["Controllers"].Base),t.prototype.published=function(){return this.view=new Y,g.get("published").then((e=this,function(t){return v.dispatch({type:"SET_ARTICLES",payload:{articles:t.resources}}),e.view.render({articles:t.resources})}));var e},t.prototype.edit=function(){var e;return e=new App.Views.Admin.Articles.Edit,App.Models.Article.find(this.params.id).then(function(t){return e.render(t),(new App.Views.Admin.Articles.Form).render(t)}),App.Models.Article.Comment.all({articleId:this.params.id}).then(function(t){return e.renderComments(t.resources)})},t.prototype.receivedSignal=function(e,t){switch(e){case"Article updated":return this.view.updateArticle(t.id);case"Article.Comment created":return this.view.commentsQuantityChangedForArticle(t.article_id,1);case"Article.Comment destroyed":return this.view.commentsQuantityChangedForArticle(t.article_id,-1)}},t}(),$=function(e){var t=e.user;return T.a.createElement("tr",{id:"user_".concat(t.id)},T.a.createElement("td",null,t.email),T.a.createElement("td",null,t.username),T.a.createElement("td",{className:"confirmed"},t.confirmed?"Yes":"No"),T.a.createElement("td",null,T.a.createElement("a",{href:"/admin/users/".concat(t.id)},"Show")," |"," ",T.a.createElement("a",{href:"/admin/users/".concat(t.id,"/edit")},"Edit")," |"," ",T.a.createElement("a",{href:"/admin/users/".concat(t.id),"data-method":"delete","data-confirm":"Are you sure?"},"Delete")," ","|"," ",T.a.createElement("a",{href:"#",onClick:function(e){return function(e,t){e.preventDefault(),n.Env.loco.emit({signal:"ping",user_id:t})}(e,t.id)}},"Ping")))};$.propTypes={user:x.a.instanceOf(S).isRequired};var G=$;function H(e){var t=e.users.map(function(e){return T.a.createElement(G,{key:"user_".concat(e.id),user:e})});return T.a.createElement(T.a.Fragment,null,t)}H.propTypes={users:x.a.arrayOf(x.a.instanceOf(S)).isRequired};var K=H;function X(e,t){return function(e){if(Array.isArray(e))return e}(e)||function(e,t){var r=[],n=!0,o=!1,i=void 0;try{for(var a,c=e[Symbol.iterator]();!(n=(a=c.next()).done)&&(r.push(a.value),!t||r.length!==t);n=!0);}catch(e){o=!0,i=e}finally{try{n||null==c.return||c.return()}finally{if(o)throw i}}return r}(e,t)||function(){throw new TypeError("Invalid attempt to destructure non-iterable instance")}()}function Z(e){var t=X(Object(C.useState)(e.users),2),r=t[0],n=t[1];return Object(C.useEffect)(function(){var e=v.subscribe(function(){return n(v.getState().users)});return function(){e()}}),T.a.createElement(K,{users:r})}Z.propTypes={users:x.a.arrayOf(x.a.instanceOf(S)).isRequired};var ee=Z;r(123);function te(e){return(te="function"==typeof Symbol&&"symbol"==typeof Symbol.iterator?function(e){return typeof e}:function(e){return e&&"function"==typeof Symbol&&e.constructor===Symbol&&e!==Symbol.prototype?"symbol":typeof e})(e)}function re(e,t){for(var r=0;r<t.length;r++){var n=t[r];n.enumerable=n.enumerable||!1,n.configurable=!0,"value"in n&&(n.writable=!0),Object.defineProperty(e,n.key,n)}}function ne(e,t){return!t||"object"!==te(t)&&"function"!=typeof t?function(e){if(void 0===e)throw new ReferenceError("this hasn't been initialised - super() hasn't been called");return e}(e):t}function oe(e){return(oe=Object.setPrototypeOf?Object.getPrototypeOf:function(e){return e.__proto__||Object.getPrototypeOf(e)})(e)}function ie(e,t){return(ie=Object.setPrototypeOf||function(e,t){return e.__proto__=t,e})(e,t)}var ae=function(e){function t(){var e,r=arguments.length>0&&void 0!==arguments[0]?arguments[0]:{};return function(e,t){if(!(e instanceof t))throw new TypeError("Cannot call a class as a function")}(this,t),(e=ne(this,oe(t).call(this,r))).user=r.user,e}var r,o,i;return function(e,t){if("function"!=typeof t&&null!==t)throw new TypeError("Super expression must either be null or a function");e.prototype=Object.create(t&&t.prototype,{constructor:{value:e,writable:!0,configurable:!0}}),t&&ie(e,t)}(t,n["Views"].Base),r=t,(o=[{key:"render",value:function(){document.getElementById("user_email").textContent=this.user.email,document.getElementById("user_username").textContent=this.user.username,document.getElementById("user_confirmed").textContent=this.user.confirmed?"Yes":"No",this._updateEditLink()}},{key:"_updateEditLink",value:function(){var e=document.getElementById("edit_link"),t=e.getAttribute("href");e.setAttribute("href",t.replace("/0/","/#{@user.id}/"))}}])&&re(r.prototype,o),i&&re(r,i),t}();function ce(e){return(ce="function"==typeof Symbol&&"symbol"==typeof Symbol.iterator?function(e){return typeof e}:function(e){return e&&"function"==typeof Symbol&&e.constructor===Symbol&&e!==Symbol.prototype?"symbol":typeof e})(e)}function ue(e,t){for(var r=0;r<t.length;r++){var n=t[r];n.enumerable=n.enumerable||!1,n.configurable=!0,"value"in n&&(n.writable=!0),Object.defineProperty(e,n.key,n)}}function le(e,t){return!t||"object"!==ce(t)&&"function"!=typeof t?function(e){if(void 0===e)throw new ReferenceError("this hasn't been initialised - super() hasn't been called");return e}(e):t}function se(e){return(se=Object.setPrototypeOf?Object.getPrototypeOf:function(e){return e.__proto__||Object.getPrototypeOf(e)})(e)}function pe(e,t){return(pe=Object.setPrototypeOf||function(e,t){return e.__proto__=t,e})(e,t)}var fe=function(e){function t(){var e,r=arguments.length>0&&void 0!==arguments[0]?arguments[0]:{};return function(e,t){if(!(e instanceof t))throw new TypeError("Cannot call a class as a function")}(this,t),(e=le(this,se(t).call(this,r))).user=r.user,e}var r,o,i;return function(e,t){if("function"!=typeof t&&null!==t)throw new TypeError("Super expression must either be null or a function");e.prototype=Object.create(t&&t.prototype,{constructor:{value:e,writable:!0,configurable:!0}}),t&&pe(e,t)}(t,n["Views"].Base),r=t,(o=[{key:"render",value:function(){new n.UI.Form({for:this.user,initObj:!0,id:"admin_user_form"}).render()}}])&&ue(r.prototype,o),i&&ue(r,i),t}();function ye(e){return(ye="function"==typeof Symbol&&"symbol"==typeof Symbol.iterator?function(e){return typeof e}:function(e){return e&&"function"==typeof Symbol&&e.constructor===Symbol&&e!==Symbol.prototype?"symbol":typeof e})(e)}function de(e,t){for(var r=0;r<t.length;r++){var n=t[r];n.enumerable=n.enumerable||!1,n.configurable=!0,"value"in n&&(n.writable=!0),Object.defineProperty(e,n.key,n)}}function me(e,t){return!t||"object"!==ye(t)&&"function"!=typeof t?function(e){if(void 0===e)throw new ReferenceError("this hasn't been initialised - super() hasn't been called");return e}(e):t}function he(e){return(he=Object.setPrototypeOf?Object.getPrototypeOf:function(e){return e.__proto__||Object.getPrototypeOf(e)})(e)}function be(e,t){return(be=Object.setPrototypeOf||function(e,t){return e.__proto__=t,e})(e,t)}var ve,_e=function(e){function t(){return function(e,t){if(!(e instanceof t))throw new TypeError("Cannot call a class as a function")}(this,t),me(this,he(t).apply(this,arguments))}var r,o,i;return function(e,t){if("function"!=typeof t&&null!==t)throw new TypeError("Super expression must either be null or a function");e.prototype=Object.create(t&&t.prototype,{constructor:{value:e,writable:!0,configurable:!0}}),t&&be(e,t)}(t,n["Controllers"].Base),r=t,(o=[{key:"index",value:function(){S.get("all").then(function(e){v.dispatch({type:"SET_USERS",payload:{users:e.resources}}),Object(R.render)(T.a.createElement(ee,{users:e.resources}),document.querySelector("table tbody"))})}},{key:"show",value:function(){S.find(this.params.id).then(function(e){return new ae({user:e}).render()})}},{key:"edit",value:function(){new fe({user:new S({id:this.params.id})}).render()}}])&&de(r.prototype,o),i&&de(r,i),t}(),ge={}.hasOwnProperty;ve=function(e){function t(){return t.__super__.constructor.apply(this,arguments)}return function(e,t){for(var r in t)ge.call(t,r)&&(e[r]=t[r]);function n(){this.constructor=e}n.prototype=t.prototype,e.prototype=new n,e.__super__=t.prototype}(t,Object(n["Mix"])(n["Controllers"].Base,P)),t.prototype.initialize=function(){return this.setScope("admin")},t}(),Object.assign(ve,{Articles:Q,Users:_e});var we=ve;function Oe(e){return(Oe="function"==typeof Symbol&&"symbol"==typeof Symbol.iterator?function(e){return typeof e}:function(e){return e&&"function"==typeof Symbol&&e.constructor===Symbol&&e!==Symbol.prototype?"symbol":typeof e})(e)}function Ee(e,t){for(var r=0;r<t.length;r++){var n=t[r];n.enumerable=n.enumerable||!1,n.configurable=!0,"value"in n&&(n.writable=!0),Object.defineProperty(e,n.key,n)}}function Se(e,t){return!t||"object"!==Oe(t)&&"function"!=typeof t?function(e){if(void 0===e)throw new ReferenceError("this hasn't been initialised - super() hasn't been called");return e}(e):t}function je(e){return(je=Object.setPrototypeOf?Object.getPrototypeOf:function(e){return e.__proto__||Object.getPrototypeOf(e)})(e)}function Ae(e,t){return(Ae=Object.setPrototypeOf||function(e,t){return e.__proto__=t,e})(e,t)}function Pe(e){for(var t=1;t<arguments.length;t++){var r=null!=arguments[t]?arguments[t]:{},n=Object.keys(r);"function"==typeof Object.getOwnPropertySymbols&&(n=n.concat(Object.getOwnPropertySymbols(r).filter(function(e){return Object.getOwnPropertyDescriptor(r,e).enumerable}))),n.forEach(function(t){Ce(e,t,r[t])})}return e}function Ce(e,t,r){return t in e?Object.defineProperty(e,t,{value:r,enumerable:!0,configurable:!0,writable:!0}):e[t]=r,e}function Te(e,t){return function(e){if(Array.isArray(e))return e}(e)||function(e,t){var r=[],n=!0,o=!1,i=void 0;try{for(var a,c=e[Symbol.iterator]();!(n=(a=c.next()).done)&&(r.push(a.value),!t||r.length!==t);n=!0);}catch(e){o=!0,i=e}finally{try{n||null==c.return||c.return()}finally{if(o)throw i}}return r}(e,t)||function(){throw new TypeError("Invalid attempt to destructure non-iterable instance")}()}var Re=function(e,t){var r=Te(p(f.getState(),e),2),n=r[0],o=r[1];n&&f.dispatch({type:"UPDATE",payload:{article:new g(Pe({},n,{commentsCount:n.commentsCount+t})),index:o}})},Ie=function(e){function t(){var e=arguments.length>0&&void 0!==arguments[0]?arguments[0]:{};return function(e,t){if(!(e instanceof t))throw new TypeError("Cannot call a class as a function")}(this,t),Se(this,je(t).call(this,e))}var r,o,i;return function(e,t){if("function"!=typeof t&&null!==t)throw new TypeError("Super expression must either be null or a function");e.prototype=Object.create(t&&t.prototype,{constructor:{value:e,writable:!0,configurable:!0}}),t&&Ae(e,t)}(t,n["Views"].Base),r=t,(o=[{key:"receivedSignal",value:function(e,t){switch(e){case"Article published":n.Env.namespaceController.constructor===we?g.find({id:t.id,abbr:!0,resource:"admin"}).then(function(e){v.dispatch({type:"PREPEND_ARTICLE",payload:{articles:[e]}})}):g.find({id:t.id,abbr:!0}).then(function(e){f.dispatch({type:"ADD",payload:{articles:[e]}})});break;case"Article updated":var r=Te(p(f.getState(),t.id),2),o=r[0],i=r[1];if(!o)break;g.find({id:t.id,abbr:!0}).then(function(e){return f.dispatch({type:"UPDATE",payload:{article:e,index:i}})});break;case"Article.Comment created":Re(t.article_id,1);break;case"Article.Comment destroyed":Re(t.article_id,-1);break;case"User created":S.find(t.id).then(function(e){return v.dispatch({type:"PREPEND_USER",payload:{users:[e]}})})}}},{key:"call",value:function(){this.connectWith([g,O,S])}}])&&Ee(r.prototype,o),i&&Ee(r,i),t}();n.Deps.cable=a.a.createConsumer(),n.Deps.NotificationCenter=c;var xe=new Ie;new n.Loco({notifications:{enable:!0,log:!0,size:10},postInit:function(){xe.call(),"test"===document.querySelector("body").getAttribute("data-rails-env")&&n.Env.loco.getWire().setPollingTime(1e3)}}).init();r(127),r(128);function ke(e,t){return function(e){if(Array.isArray(e))return e}(e)||function(e,t){var r=[],n=!0,o=!1,i=void 0;try{for(var a,c=e[Symbol.iterator]();!(n=(a=c.next()).done)&&(r.push(a.value),!t||r.length!==t);n=!0);}catch(e){o=!0,i=e}finally{try{n||null==c.return||c.return()}finally{if(o)throw i}}return r}(e,t)||function(){throw new TypeError("Invalid attempt to destructure non-iterable instance")}()}function De(){var e=ke(Object(C.useState)(1),2),t=e[0],r=e[1],n=ke(Object(C.useState)(!1),2),o=n[0],i=n[1];function a(e){e.preventDefault();var n=t+1;r(n),g.get("all",{page:n}).then(function(e){e.resources.length>0?f.dispatch({type:"ADD",payload:{articles:e.resources}}):i(!0)}).catch(function(e){return alert("Invalid URL: ".concat(e))})}return o?T.a.createElement("span",null,"No more posts."):T.a.createElement("a",{href:"#",id:"load_more",onClick:a},"Load more…")}function Ne(e){var t=e.article,r=new n.Services.Date(t.publishedAt).toString("short");return T.a.createElement("article",{id:"article_".concat(t.id)},T.a.createElement("h2",null,t.title),T.a.createElement("p",null,T.a.createElement("i",null,t.author," wrote this on ",r," /"," ",T.a.createElement("a",{href:"/articles/".concat(t.id,"#comments"),className:"comments_quantity"},t.commentsCount," comment",1===t.commentsCount?"":"s"))),T.a.createElement("p",null,t.content),T.a.createElement("p",null,T.a.createElement("a",{href:"/articles/".concat(t.id)},"Continued…")))}Ne.propTypes={article:x.a.instanceOf(g).isRequired};var Be=Ne;function Le(e){var t=e.articles.map(function(e){return T.a.createElement(Be,{key:"article_".concat(e.id),article:e})});return T.a.createElement(T.a.Fragment,null,t)}Le.propTypes={articles:x.a.arrayOf(x.a.instanceOf(g)).isRequired};var Ue=Le;function qe(e,t){return function(e){if(Array.isArray(e))return e}(e)||function(e,t){var r=[],n=!0,o=!1,i=void 0;try{for(var a,c=e[Symbol.iterator]();!(n=(a=c.next()).done)&&(r.push(a.value),!t||r.length!==t);n=!0);}catch(e){o=!0,i=e}finally{try{n||null==c.return||c.return()}finally{if(o)throw i}}return r}(e,t)||function(){throw new TypeError("Invalid attempt to destructure non-iterable instance")}()}function Me(e){var t=qe(Object(C.useState)(e.articles),2),r=t[0],n=t[1];return Object(C.useEffect)(function(){var e=f.subscribe(function(){return n(f.getState().articles)});return function(){e()}}),T.a.createElement(Ue,{articles:r})}Me.propTypes={articles:x.a.arrayOf(x.a.instanceOf(g)).isRequired};var Ve=Me;function Fe(e){return(Fe="function"==typeof Symbol&&"symbol"==typeof Symbol.iterator?function(e){return typeof e}:function(e){return e&&"function"==typeof Symbol&&e.constructor===Symbol&&e!==Symbol.prototype?"symbol":typeof e})(e)}function ze(e,t){for(var r=0;r<t.length;r++){var n=t[r];n.enumerable=n.enumerable||!1,n.configurable=!0,"value"in n&&(n.writable=!0),Object.defineProperty(e,n.key,n)}}function We(e,t){return!t||"object"!==Fe(t)&&"function"!=typeof t?function(e){if(void 0===e)throw new ReferenceError("this hasn't been initialised - super() hasn't been called");return e}(e):t}function Ye(e){return(Ye=Object.setPrototypeOf?Object.getPrototypeOf:function(e){return e.__proto__||Object.getPrototypeOf(e)})(e)}function Je(e,t){return(Je=Object.setPrototypeOf||function(e,t){return e.__proto__=t,e})(e,t)}var Qe,$e=function(e){function t(){return function(e,t){if(!(e instanceof t))throw new TypeError("Cannot call a class as a function")}(this,t),We(this,Ye(t).apply(this,arguments))}var r,o,i;return function(e,t){if("function"!=typeof t&&null!==t)throw new TypeError("Super expression must either be null or a function");e.prototype=Object.create(t&&t.prototype,{constructor:{value:e,writable:!0,configurable:!0}}),t&&Je(e,t)}(t,n["Controllers"].Base),r=t,(o=[{key:"index",value:function(){Object(R.render)(T.a.createElement(De,null),document.getElementById("load_more_wrapper")),g.get("all",{page:1}).then(function(e){f.dispatch({type:"SET",payload:{articles:e.resources}}),Object(R.render)(T.a.createElement(Ve,{articles:e.resources}),document.getElementById("articles"))})}}])&&ze(r.prototype,o),i&&ze(r,i),t}(),Ge={}.hasOwnProperty,He=function(e){function t(e){null==e&&(e={}),t.__super__.constructor.call(this,e)}return function(e,t){for(var r in t)Ge.call(t,r)&&(e[r]=t[r]);function n(){this.constructor=e}n.prototype=t.prototype,e.prototype=new n,e.__super__=t.prototype}(t,n["Views"].Base),t.prototype.render=function(){return new n.UI.Form({for:new S,delegator:this,callbackSuccess:"_created"}).render()},t.prototype.receivedSignal=function(e,t){switch(e){case"confirming":return this._confirming();case"confirmed":return this._confirmed()}},t.prototype._created=function(e){return this.connectWith(new S({id:e.id})),document.querySelector("form").style.display="none",document.getElementById("sign_in_paragraph").classList.remove("none"),document.getElementById("verification_info").classList.remove("none"),new A({notice:e.notice}).render()},t.prototype._confirming=function(){return document.getElementById("verification_info").textContent=document.getElementById("verification_progress").textContent},t.prototype._confirmed=function(){return window.location.href="/user/sessions/new?event=confirmed"},t}(),Ke={}.hasOwnProperty,Xe=function(e){function t(){return t.__super__.constructor.apply(this,arguments)}return function(e,t){for(var r in t)Ke.call(t,r)&&(e[r]=t[r]);function n(){this.constructor=e}n.prototype=t.prototype,e.prototype=new n,e.__super__=t.prototype}(t,n["Controllers"].Base),t.prototype.new=function(){return(new He).render()},t}(),Ze={}.hasOwnProperty;Qe=function(e){function t(){return t.__super__.constructor.apply(this,arguments)}return function(e,t){for(var r in t)Ze.call(t,r)&&(e[r]=t[r]);function n(){this.constructor=e}n.prototype=t.prototype,e.prototype=new n,e.__super__=t.prototype}(t,Object(n["Mix"])(n["Controllers"].Base,P)),t.prototype.initialize=function(){return this.setScope("main")},t}(),Object.assign(Qe,{Pages:$e,Users:Xe});var et=Qe;Object.assign(g,{Comment:O});var tt={Article:g,User:S};Object.assign(n.Models,tt),Object.assign(n.Controllers,{Admin:we,Main:et})}});
//# sourceMappingURL=application.js.map