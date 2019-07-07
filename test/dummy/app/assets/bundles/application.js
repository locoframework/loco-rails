!function(e){function t(t){for(var r,a,c=t[0],l=t[1],s=t[2],p=0,d=[];p<c.length;p++)a=c[p],o[a]&&d.push(o[a][0]),o[a]=0;for(r in l)Object.prototype.hasOwnProperty.call(l,r)&&(e[r]=l[r]);for(u&&u(t);d.length;)d.shift()();return i.push.apply(i,s||[]),n()}function n(){for(var e,t=0;t<i.length;t++){for(var n=i[t],r=!0,c=1;c<n.length;c++){var l=n[c];0!==o[l]&&(r=!1)}r&&(i.splice(t--,1),e=a(a.s=n[0]))}return e}var r={},o={0:0},i=[];function a(t){if(r[t])return r[t].exports;var n=r[t]={i:t,l:!1,exports:{}};return e[t].call(n.exports,n,n.exports,a),n.l=!0,n.exports}a.m=e,a.c=r,a.d=function(e,t,n){a.o(e,t)||Object.defineProperty(e,t,{enumerable:!0,get:n})},a.r=function(e){"undefined"!=typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(e,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(e,"__esModule",{value:!0})},a.t=function(e,t){if(1&t&&(e=a(e)),8&t)return e;if(4&t&&"object"==typeof e&&e&&e.__esModule)return e;var n=Object.create(null);if(a.r(n),Object.defineProperty(n,"default",{enumerable:!0,value:e}),2&t&&"string"!=typeof e)for(var r in e)a.d(n,r,function(t){return e[t]}.bind(null,r));return n},a.n=function(e){var t=e&&e.__esModule?function(){return e.default}:function(){return e};return a.d(t,"a",t),t},a.o=function(e,t){return Object.prototype.hasOwnProperty.call(e,t)},a.p="";var c=window.webpackJsonp=window.webpackJsonp||[],l=c.push.bind(c);c.push=t,c=c.slice();for(var s=0;s<c.length;s++)t(c[s]);var u=l;i.push([75,1]),n()}({53:function(e,t,n){},54:function(e,t,n){},75:function(e,t,n){"use strict";n.r(t);n(38);var r=n(0),o=n(35);n.n(o).a.start();var i=n(36),a=n.n(i),c=function(){function e(){}return e.prototype.receivedSignal=function(e){switch(e.signal){case"ping":return this._pingSignal();case"message":return this._messageSignal(e)}},e.prototype._pingSignal=function(){if(r.Env.namespaceController.constructor===App.Controllers.User)return alert("Ping!")},e.prototype._messageSignal=function(e){var t;if(t=this._getRoomView())return t.receivedMessage(e.message,e.author)},e.prototype._getRoomView=function(){return r.Env.namespaceController.constructor===App.Controllers.User&&(r.Env.controller.constructor===App.Controllers.User.Rooms&&("show"===r.Env.action&&r.Env.controller.getView("show")))},e}();r.Deps.cable=a.a.createConsumer(),r.Deps.NotificationCenter=c,new r.Loco({notifications:{enable:!0,log:!0,size:10},postInit:function(){"test"===document.querySelector("body").getAttribute("data-rails-env")&&r.Env.loco.getWire().setPollingTime(1e3)}}).init();n(53),n(54);var l={}.hasOwnProperty,s=function(e){function t(e){var n,r,o,i;null==e&&(e={}),t.__super__.constructor.call(this,e),this.notice=null!=(n=e.notice)?n:null,this.alert=null!=(r=e.alert)?r:null,this.warning=null!=(o=e.warning)?o:null,this.hide=null==(i=e.hide)||i}return function(e,t){for(var n in t)l.call(t,n)&&(e[n]=t[n]);function r(){this.constructor=e}r.prototype=t.prototype,e.prototype=new r,e.__super__=t.prototype}(t,r["Views"].Base),t.prototype.setNotice=function(e){return this.notice=e},t.prototype.setAlert=function(e){return this.alert=e},t.prototype.setWarning=function(e){return this.warning=e},t.prototype.render=function(){var e;if((e=document.querySelector(".flash")).classList.remove("notice"),e.classList.remove("alert"),e.classList.remove("warning"),null!=this.notice?(e.classList.add("notice"),document.querySelector(".flash p").textContent=this.notice):null!=this.alert?(e.classList.add("alert"),document.querySelector(".flash p").textContent=this.alert):null!=this.warning&&(e.classList.add("warning"),document.querySelector(".flash p").textContent=this.warning),e.classList.remove("none"),this.hide)return this.hideAfterTime()},t.prototype.hideAfterTime=function(e){return null==e&&(e=4e3),setTimeout(function(){return document.querySelector(".flash").classList.add("none")},e)},t}(),u=function(){function e(){}return e.prototype.disconnectedForTooLong=function(e){return"You have been disconnected from the server for too long. Reload page!",new s({alert:"You have been disconnected from the server for too long. Reload page!",hide:!1}).render()},e}(),p=n(1),d=n.n(p),m=n(37),f={}.hasOwnProperty,h=function(e){function t(e){t.__super__.constructor.call(this,e),this.published=null!=this.publishedAt}return function(e,t){for(var n in t)f.call(t,n)&&(e[n]=t[n]);function r(){this.constructor=e}r.prototype=t.prototype,e.prototype=new r,e.__super__=t.prototype}(t,r["Models"].Base),t.identity="Article",t.resources={url:"/user/articles",paginate:{per:5},main:{url:"/articles",paginate:{per:3}},admin:{url:"/admin/articles",paginate:{per:4}}},t.attributes={title:{validations:{presence:!0,length:{within:[3,255]}}},content:{validations:{presence:!0,length:{minimum:100}},remoteName:"text"},createdAt:{type:"Date",remoteName:"created_at"},updatedAt:{type:"Date",remoteName:"updated_at"},commentsCount:{type:"Int",remoteName:"comments_count"},publishedAt:{type:"Date",remoteName:"published_at"},published:{},adminReview:{remoteName:"admin_review"},adminRate:{type:"Int",remoteName:"admin_rate"},categoryId:{type:"Int",remoteName:"category_id"},adminReviewStartedAt:{remoteName:"admin_review_started_at"}},t.receivedSignal=function(e,t){},t.validate=["vulgarityLevel"],t.prototype.receivedSignal=function(e,t){},t.prototype.vulgarityLevel=function(){if(null!=this.title&&/fuck/i.exec(this.title)||null!=this.content&&/fuck/i.exec(this.content))return this.addErrorMessage("Article contains strong language.",{for:"base"})},t.prototype.setDefaultValuesForAdminReview=function(){return null==this.adminRate&&(this.adminRate=3),null==this.categoryId&&(this.categoryId=6),this.adminReviewStartedAt=Date.now()},t}(),y={}.hasOwnProperty,_=function(e){function t(e){t.__super__.constructor.call(this,e)}return function(e,t){for(var n in t)y.call(t,n)&&(e[n]=t[n]);function r(){this.constructor=e}r.prototype=t.prototype,e.prototype=new r,e.__super__=t.prototype}(t,r["Models"].Base),t.identity="Article.Comment",t.remoteName="Comment",t.resources={url:"/user/articles/:articleId/comments",paginate:{per:10},main:{url:"/articles/:articleId/comments",paginate:{per:5,param:"page-num"}},admin:{url:"/admin/articles/:articleId/comments",paginate:{per:5}}},t.attributes={author:{validations:{presence:!0}},text:{validations:{presence:!0,vulgarity:!0}},articleId:{type:"Int",validations:{presence:!0},remoteName:"article_id"},createdAt:{type:"Date",remoteName:"created_at"},updatedAt:{type:"Date",remoteName:"updated_at"},emotion:{type:"Int"},pinned:{type:"Boolean"},adminRate:{type:"Int",remoteName:"admin_rate"},approved:{type:"Boolean"}},t.receivedSignal=function(e,t){},t.prototype.receivedSignal=function(e,t){},t}(),g=(n(60),n(7)),v=n.n(g);n(70),n(73);function w(e){var t=e.article,n=new r.Services.Date(t.publishedAt).toString("short");return d.a.createElement("article",{id:"article_".concat(t.id)},d.a.createElement("h2",null,t.title),d.a.createElement("p",null,d.a.createElement("i",null,t.author," wrote this on ",n," /"," ",d.a.createElement("a",{href:"/articles/".concat(t.id,"#comments"),className:"comments_quantity"},t.commentsCount," comment",1===t.commentsCount?"":"s"))),d.a.createElement("p",null,t.content),d.a.createElement("p",null,d.a.createElement("a",{href:"/articles/".concat(t.id)},"Continued…")))}w.propTypes={article:v.a.instanceOf(h).isRequired};var b=w;function A(e){var t=e.articles.map(function(e){return d.a.createElement(b,{key:"article_".concat(e.id),article:e})});return d.a.createElement(d.a.Fragment,null,t)}A.propTypes={articles:v.a.arrayOf(v.a.instanceOf(h)).isRequired};var S,C=A,E={}.hasOwnProperty,I=function(e){function t(e){null==e&&(e={}),t.__super__.constructor.call(this,e),this.page=1}return function(e,t){for(var n in t)E.call(t,n)&&(e[n]=t[n]);function r(){this.constructor=e}r.prototype=t.prototype,e.prototype=new r,e.__super__=t.prototype}(t,r["Views"].Base),t.prototype.receivedSignal=function(e,t){switch(e){case"Article published":return h.find({id:t.id,abbr:!0}).then((n=this,function(e){return n._renderNewArticle(e)}));case"Article updated":return this._updateArticle(t.id);case"Article.Comment created":return this._commentsQuantityChangedForArticle(t.article_id,1);case"Article.Comment destroyed":return this._commentsQuantityChangedForArticle(t.article_id,-1)}var n},t.prototype.render=function(){return this._handleLoadMore(),this.connectWith([h,_]),h.get("all",{page:1}).then((e=this,function(t){return e._renderArticles(t.resources)}));var e},t.prototype._renderArticles=function(e){return Object(m.render)(d.a.createElement(C,{articles:e}),document.getElementById("articles"))},t.prototype._renderNewArticle=function(e){return document.getElementById("articles").insertAdjacentHTML("afterbegin",this._renderedArticle(e))},t.prototype._updateArticle=function(e){var t;if(document.getElementById("article_"+e))return h.find({id:e,abbr:!0}).then((t=this,function(e){return document.getElementById("article_"+e.id).outerHTML=t._renderedArticle(e)}))},t.prototype._commentsQuantityChangedForArticle=function(e,t){var n,r;if(document.getElementById("article_"+e))return r=document.querySelector("#article_"+e+" a.comments_quantity"),n=/\d+/.exec(r.textContent),t=parseInt(n[0])+t,r.textContent=t+" comment"+(1===t?"":"s")},t.prototype._handleLoadMore=function(){return document.getElementById("load_more").addEventListener("click",(e=this,function(t){return t.preventDefault(),e.page+=1,h.get("all",{page:e.page}).then(function(t){return t.resources.length>0?e._renderArticles(t.resources):document.getElementById("load_more").outerHTML="<p>No more posts.</p>"}).catch(function(e){return alert("Invalid URL")})}));var e},t.prototype._renderedArticle=function(e){return JST["templates/main/articles/article_for_list"]({article:e})},t}(),O={}.hasOwnProperty,N=function(e){function t(){return t.__super__.constructor.apply(this,arguments)}return function(e,t){for(var n in t)O.call(t,n)&&(e[n]=t[n]);function r(){this.constructor=e}r.prototype=t.prototype,e.prototype=new r,e.__super__=t.prototype}(t,r["Controllers"].Base),t.prototype.index=function(){return(new I).render()},t}(),L={}.hasOwnProperty;S=function(e){function t(){return t.__super__.constructor.apply(this,arguments)}return function(e,t){for(var n in t)L.call(t,n)&&(e[n]=t[n]);function r(){this.constructor=e}r.prototype=t.prototype,e.prototype=new r,e.__super__=t.prototype}(t,Object(r["Mix"])(r["Controllers"].Base,u)),t.prototype.initialize=function(){return this.setScope("main")},t}(),Object.assign(S,{Pages:N});var x=S;Object.assign(r.Controllers,{Main:x})}});