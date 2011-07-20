#!/bin/bash

mkdir gllry
### HTML HEADER START ###
cat > ./gllry/index.html << EOF 
<!DOCTYPE html>

<!--
  Google HTML5 slide template

  Authors: Luke Mahé (code)
           Marcin Wichary (code and design)
           
           Dominic Mazzoni (browser compatibility)
           Charles Chen (ChromeVox support)

  URL: http://code.google.com/p/html5slides/
-->

<html>
  <head>
    <title>gllry</title>

    <meta charset='utf-8'>
    <script>
      /*
  Google HTML5 slides template

  Authors: Luke Mahé (code)
           Marcin Wichary (code and design)

           Dominic Mazzoni (browser compatibility)
           Charles Chen (ChromeVox support)

  URL: http://code.google.com/p/html5slides/
*/

var SLIDE_CLASSES = ['far-past', 'past', 'current', 'next', 'far-next'];

var PM_TOUCH_SENSITIVITY = 15;

var curSlide;

/* ---------------------------------------------------------------------- */
/* classList polyfill by Eli Grey 
 * (http://purl.eligrey.com/github/classList.js/blob/master/classList.js) */

if (typeof document !== "undefined" && !("classList" in document.createElement("a"))) {

(function (view) {

var
    classListProp = "classList"
  , protoProp = "prototype"
  , elemCtrProto = (view.HTMLElement || view.Element)[protoProp]
  , objCtr = Object
    strTrim = String[protoProp].trim || function () {
    return this.replace(/^\s+|\s+$/g, "");
  }
  , arrIndexOf = Array[protoProp].indexOf || function (item) {
    for (var i = 0, len = this.length; i < len; i++) {
      if (i in this && this[i] === item) {
        return i;
      }
    }
    return -1;
  }
  // Vendors: please allow content code to instantiate DOMExceptions
  , DOMEx = function (type, message) {
    this.name = type;
    this.code = DOMException[type];
    this.message = message;
  }
  , checkTokenAndGetIndex = function (classList, token) {
    if (token === "") {
      throw new DOMEx(
          "SYNTAX_ERR"
        , "An invalid or illegal string was specified"
      );
    }
    if (/\s/.test(token)) {
      throw new DOMEx(
          "INVALID_CHARACTER_ERR"
        , "String contains an invalid character"
      );
    }
    return arrIndexOf.call(classList, token);
  }
  , ClassList = function (elem) {
    var
        trimmedClasses = strTrim.call(elem.className)
      , classes = trimmedClasses ? trimmedClasses.split(/\s+/) : []
    ;
    for (var i = 0, len = classes.length; i < len; i++) {
      this.push(classes[i]);
    }
    this._updateClassName = function () {
      elem.className = this.toString();
    };
  }
  , classListProto = ClassList[protoProp] = []
  , classListGetter = function () {
    return new ClassList(this);
  }
;
// Most DOMException implementations don't allow calling DOMException's toString()
// on non-DOMExceptions. Error's toString() is sufficient here.
DOMEx[protoProp] = Error[protoProp];
classListProto.item = function (i) {
  return this[i] || null;
};
classListProto.contains = function (token) {
  token += "";
  return checkTokenAndGetIndex(this, token) !== -1;
};
classListProto.add = function (token) {
  token += "";
  if (checkTokenAndGetIndex(this, token) === -1) {
    this.push(token);
    this._updateClassName();
  }
};
classListProto.remove = function (token) {
  token += "";
  var index = checkTokenAndGetIndex(this, token);
  if (index !== -1) {
    this.splice(index, 1);
    this._updateClassName();
  }
};
classListProto.toggle = function (token) {
  token += "";
  if (checkTokenAndGetIndex(this, token) === -1) {
    this.add(token);
  } else {
    this.remove(token);
  }
};
classListProto.toString = function () {
  return this.join(" ");
};

if (objCtr.defineProperty) {
  var classListPropDesc = {
      get: classListGetter
    , enumerable: true
    , configurable: true
  };
  try {
    objCtr.defineProperty(elemCtrProto, classListProp, classListPropDesc);
  } catch (ex) { // IE 8 doesn't support enumerable:true
    if (ex.number === -0x7FF5EC54) {
      classListPropDesc.enumerable = false;
      objCtr.defineProperty(elemCtrProto, classListProp, classListPropDesc);
    }
  }
} else if (objCtr[protoProp].__defineGetter__) {
  elemCtrProto.__defineGetter__(classListProp, classListGetter);
}

}(self));

}
/* ---------------------------------------------------------------------- */

/* Slide movement */

function getSlideEl(no) {
  if ((no < 0) || (no >= slideEls.length)) { 
    return null;
  } else {
    return slideEls[no];
  }
};

function updateSlideClass(slideNo, className) {
  var el = getSlideEl(slideNo);
  
  if (!el) {
    return;
  }
  
  if (className) {
    el.classList.add(className);
  }
    
  for (var i in SLIDE_CLASSES) {
    if (className != SLIDE_CLASSES[i]) {
      el.classList.remove(SLIDE_CLASSES[i]);
    }
  }
};

function updateSlides() {
  for (var i = 0; i < slideEls.length; i++) {
    switch (i) {
      case curSlide - 2:
        updateSlideClass(i, 'far-past');
        break;
      case curSlide - 1:
        updateSlideClass(i, 'past');
        break;
      case curSlide: 
        updateSlideClass(i, 'current');
        break;
      case curSlide + 1:
        updateSlideClass(i, 'next');      
        break;
      case curSlide + 2:
        updateSlideClass(i, 'far-next');      
        break;
      default:
        updateSlideClass(i);
        break;
    }
  }

  triggerLeaveEvent(curSlide - 1);
  triggerEnterEvent(curSlide);

  window.setTimeout(function() {
    // Hide after the slide
    disableSlideFrames(curSlide - 2);
  }, 301);

  enableSlideFrames(curSlide - 1);
  enableSlideFrames(curSlide + 2);
  
  if (isChromeVoxActive()) {
    speakAndSyncToNode(slideEls[curSlide]);
  }  

  updateHash();
};

function buildNextItem() {
  var toBuild  = slideEls[curSlide].querySelectorAll('.to-build');

  if (!toBuild.length) {
    return false;
  }

  toBuild[0].classList.remove('to-build', '');

  if (isChromeVoxActive()) {
    speakAndSyncToNode(toBuild[0]);
  }

  return true;
};

function prevSlide() {
  if (curSlide > 0) {
    curSlide--;

    updateSlides();
  }
};

function nextSlide() {
  if (buildNextItem()) {
    return;
  }

  if (curSlide < slideEls.length - 1) {
    curSlide++;

    updateSlides();
  }
};

/* Slide events */

function triggerEnterEvent(no) {
  var el = getSlideEl(no);
  if (!el) {
    return;
  }

  var onEnter = el.getAttribute('onslideenter');
  if (onEnter) {
    new Function(onEnter).call(el);
  }

  var evt = document.createEvent('Event');
  evt.initEvent('slideenter', true, true);
  evt.slideNumber = no + 1; // Make it readable

  el.dispatchEvent(evt);
};

function triggerLeaveEvent(no) {
  var el = getSlideEl(no);
  if (!el) {
    return;
  }

  var onLeave = el.getAttribute('onslideleave');
  if (onLeave) {
    new Function(onLeave).call(el);
  }

  var evt = document.createEvent('Event');
  evt.initEvent('slideleave', true, true);
  evt.slideNumber = no + 1; // Make it readable
  
  el.dispatchEvent(evt);
};

/* Touch events */

function handleTouchStart(event) {
  if (event.touches.length == 1) {
    touchDX = 0;
    touchDY = 0;

    touchStartX = event.touches[0].pageX;
    touchStartY = event.touches[0].pageY;

    document.body.addEventListener('touchmove', handleTouchMove, true);
    document.body.addEventListener('touchend', handleTouchEnd, true);
  }
};

function handleTouchMove(event) {
  if (event.touches.length > 1) {
    cancelTouch();
  } else {
    touchDX = event.touches[0].pageX - touchStartX;
    touchDY = event.touches[0].pageY - touchStartY;
  }
};

function handleTouchEnd(event) {
  var dx = Math.abs(touchDX);
  var dy = Math.abs(touchDY);

  if ((dx > PM_TOUCH_SENSITIVITY) && (dy < (dx * 2 / 3))) {
    if (touchDX > 0) {
      prevSlide();
    } else {
      nextSlide();
    }
  }
  
  cancelTouch();
};

function cancelTouch() {
  document.body.removeEventListener('touchmove', handleTouchMove, true);
  document.body.removeEventListener('touchend', handleTouchEnd, true);  
};

/* Preloading frames */

function disableSlideFrames(no) {
  var el = getSlideEl(no);
  if (!el) {
    return;
  }

  var frames = el.getElementsByTagName('iframe');
  for (var i = 0, frame; frame = frames[i]; i++) {
    disableFrame(frame);
  }
};

function enableSlideFrames(no) {
  var el = getSlideEl(no);
  if (!el) {
    return;
  }

  var frames = el.getElementsByTagName('iframe');
  for (var i = 0, frame; frame = frames[i]; i++) {
    enableFrame(frame);
  }
};

function disableFrame(frame) {
  frame.src = 'about:blank';
};

function enableFrame(frame) {
  var src = frame._src;

  if (frame.src != src && src != 'about:blank') {
    frame.src = src;
  }
};

function setupFrames() {
  var frames = document.querySelectorAll('iframe');
  for (var i = 0, frame; frame = frames[i]; i++) {
    frame._src = frame.src;
    disableFrame(frame);
  }
  
  enableSlideFrames(curSlide);
  enableSlideFrames(curSlide + 1);
  enableSlideFrames(curSlide + 2);  
};

function setupInteraction() {
  /* Clicking and tapping */
  
  var el = document.createElement('div');
  el.className = 'slide-area';
  el.id = 'prev-slide-area';  
  el.addEventListener('click', prevSlide, false);
  document.querySelector('section.slides').appendChild(el);

  var el = document.createElement('div');
  el.className = 'slide-area';
  el.id = 'next-slide-area';  
  el.addEventListener('click', nextSlide, false);
  document.querySelector('section.slides').appendChild(el);  
  
  /* Swiping */
  
  document.body.addEventListener('touchstart', handleTouchStart, false);
}

/* ChromeVox support */

function isChromeVoxActive() {
  if (typeof(cvox) == 'undefined') {
    return false;
  } else {
    return true;
  }
};

function speakAndSyncToNode(node) {
  if (!isChromeVoxActive()) {
    return;
  }
  
  cvox.ChromeVox.navigationManager.switchToStrategy(
      cvox.ChromeVoxNavigationManager.STRATEGIES.LINEARDOM, 0, true);  
  cvox.ChromeVox.navigationManager.syncToNode(node);
  cvox.ChromeVoxUserCommands.finishNavCommand('');
  var target = node;
  while (target.firstChild) {
    target = target.firstChild;
  }
  cvox.ChromeVox.navigationManager.syncToNode(target);
};

function speakNextItem() {
  if (!isChromeVoxActive()) {
    return;
  }
  
  cvox.ChromeVox.navigationManager.switchToStrategy(
      cvox.ChromeVoxNavigationManager.STRATEGIES.LINEARDOM, 0, true);
  cvox.ChromeVox.navigationManager.next(true);
  if (!cvox.DomUtil.isDescendantOfNode(
      cvox.ChromeVox.navigationManager.getCurrentNode(), slideEls[curSlide])){
    var target = slideEls[curSlide];
    while (target.firstChild) {
      target = target.firstChild;
    }
    cvox.ChromeVox.navigationManager.syncToNode(target);
    cvox.ChromeVox.navigationManager.next(true);
  }
  cvox.ChromeVoxUserCommands.finishNavCommand('');
};

function speakPrevItem() {
  if (!isChromeVoxActive()) {
    return;
  }
  
  cvox.ChromeVox.navigationManager.switchToStrategy(
      cvox.ChromeVoxNavigationManager.STRATEGIES.LINEARDOM, 0, true);
  cvox.ChromeVox.navigationManager.previous(true);
  if (!cvox.DomUtil.isDescendantOfNode(
      cvox.ChromeVox.navigationManager.getCurrentNode(), slideEls[curSlide])){
    var target = slideEls[curSlide];
    while (target.lastChild){
      target = target.lastChild;
    }
    cvox.ChromeVox.navigationManager.syncToNode(target);
    cvox.ChromeVox.navigationManager.previous(true);
  }
  cvox.ChromeVoxUserCommands.finishNavCommand('');
};

/* Hash functions */

function getCurSlideFromHash() {
  var slideNo = parseInt(location.hash.substr(1));

  if (slideNo) {
    curSlide = slideNo - 1;
  } else {
    curSlide = 0;
  }
};

function updateHash() {
  location.replace('#' + (curSlide + 1));
};

/* Event listeners */

function handleBodyKeyDown(event) {
  switch (event.keyCode) {
    case 39: // right arrow
    case 13: // Enter
    case 32: // space
    case 34: // PgDn
      nextSlide();
      event.preventDefault();
      break;

    case 37: // left arrow
    case 8: // Backspace
    case 33: // PgUp
      prevSlide();
      event.preventDefault();
      break;

    case 40: // down arrow
      if (isChromeVoxActive()) {
        speakNextItem();
      } else {
        nextSlide();
      }
      event.preventDefault();
      break;

    case 38: // up arrow
      if (isChromeVoxActive()) {
        speakPrevItem();
      } else {
        prevSlide();
      }
      event.preventDefault();
      break;
  }
};

function addEventListeners() {
  document.addEventListener('keydown', handleBodyKeyDown, false);  
};

/* Initialization */


function addFontStyle() {
  var el = document.createElement('link');
  el.rel = 'stylesheet';
  el.type = 'text/css';
  el.href = 'http://fonts.googleapis.com/css?family=' +
            'Open+Sans:regular,semibold,italic,italicsemibold|Droid+Sans+Mono';

  document.body.appendChild(el);
};

function addGeneralStyle() {

  
  var el = document.createElement('meta');
  el.name = 'viewport';
  el.content = 'width=1100,height=750';
  document.querySelector('head').appendChild(el);
  
  var el = document.createElement('meta');
  el.name = 'apple-mobile-web-app-capable';
  el.content = 'yes';
  document.querySelector('head').appendChild(el);
};

function makeBuildLists() {
  for (var i = curSlide, slide; slide = slideEls[i]; i++) {
    var items = slide.querySelectorAll('.build > *');
    for (var j = 0, item; item = items[j]; j++) {
      if (item.classList) {
        item.classList.add('to-build');
      }
    }
  }
};

function handleDomLoaded() {
  slideEls = document.querySelectorAll('section.slides > article');

  setupFrames();

  addFontStyle();
  addGeneralStyle();

  addEventListeners();

  updateSlides();

  setupInteraction();
  makeBuildLists();

  document.body.classList.add('loaded');
};

function initialize() {
  getCurSlideFromHash();

  if (window['_DCL']) {
    handleDomLoaded();
  } else {
    document.addEventListener('DOMContentLoaded', handleDomLoaded, false);
  }
}


initialize();

</script>


  </head>
  
  <style>
    /*
  Google HTML5 slides template

  Authors: Luke Mahé (code)
           Marcin Wichary (code and design)
           
           Dominic Mazzoni (browser compatibility)
           Charles Chen (ChromeVox support)

  URL: http://code.google.com/p/html5slides/
*/

/* Framework */

html {
  height: 100%;
}

body {
  margin: 0;
  padding: 0;

  display: block !important;

  height: 100%;
  min-height: 740px;
  
  overflow-x: hidden;
  overflow-y: auto;

  background: rgb(215, 215, 215);
  background: -o-radial-gradient(rgb(240, 240, 240), rgb(190, 190, 190));
  background: -moz-radial-gradient(rgb(240, 240, 240), rgb(190, 190, 190));
  background: -webkit-radial-gradient(rgb(240, 240, 240), rgb(190, 190, 190));
  background: -webkit-gradient(radial, 50% 50%, 0, 50% 50%, 500, from(rgb(240, 240, 240)), to(rgb(190, 190, 190)));

  -webkit-font-smoothing: antialiased;
}

.slides {
  width: 100%;
  height: 100%;
  left: 0;
  top: 0;
  
  position: absolute;

  -webkit-transform: translate3d(0, 0, 0);
}

.slides > article {
  display: block;

  position: absolute;
  overflow: hidden;

  width: 900px;
  height: 700px;

  left: 50%;
  top: 50%;

  margin-left: -450px;
  margin-top: -350px;
  
  padding: 40px 60px;

  box-sizing: border-box;
  -o-box-sizing: border-box;
  -moz-box-sizing: border-box;
  -webkit-box-sizing: border-box;

  border-radius: 10px;
  -o-border-radius: 10px;
  -moz-border-radius: 10px;
  -webkit-border-radius: 10px;

  background-color: white;

  box-shadow: 0 2px 6px rgba(0, 0, 0, .1);
  border: 1px solid rgba(0, 0, 0, .3);

  transition: transform .3s ease-out;
  -o-transition: -o-transform .3s ease-out;
  -moz-transition: -moz-transform .3s ease-out;
  -webkit-transition: -webkit-transform .3s ease-out;
}
.slides.layout-widescreen > article {
  margin-left: -550px;
  width: 1100px;
}
.slides.layout-faux-widescreen > article {
  margin-left: -550px;
  width: 1100px;
  
  padding: 40px 160px;
}

.slides.template-default > article:not(.nobackground):not(.biglogo) {
  background: url(images/google-logo-small.png) 710px 625px no-repeat;  
  
  background-color: white;  
} 

.slides.template-io2011 > article:not(.nobackground):not(.biglogo) {
  background: url(images/colorbar.png) 0 600px repeat-x,
              url(images/googleio-logo.png) 640px 625px no-repeat;

  background-size: 100%, 225px;  

  background-color: white;  
}
.slides.layout-widescreen > article:not(.nobackground):not(.biglogo),
.slides.layout-faux-widescreen > article:not(.nobackground):not(.biglogo) {
  background-position-x: 0, 840px;
}

/* Clickable/tappable areas */

.slide-area {
  z-index: 1000;

  position: absolute;
  left: 0;
  top: 0;
  width: 150px;
  height: 700px;  

  left: 50%;
  top: 50%;

  cursor: pointer;  
  margin-top: -350px;  
  
  tap-highlight-color: transparent;
  -o-tap-highlight-color: transparent;
  -moz-tap-highlight-color: transparent;
  -webkit-tap-highlight-color: transparent;
}

.slides.layout-widescreen #prev-slide-area,
.slides.layout-faux-widescreen #prev-slide-area {
  margin-left: -650px;
}
.slides.layout-widescreen #next-slide-area,
.slides.layout-faux-widescreen #next-slide-area {
  margin-left: 500px;
}

/* Slides */

.slides > article {
  display: none;
}
.slides > article.far-past {
  display: block;
  transform: translate(-2040px);
  -o-transform: translate(-2040px);
  -moz-transform: translate(-2040px);
  -webkit-transform: translate3d(-2040px, 0, 0);
}
.slides > article.past {
  display: block;
  transform: translate(-1020px);
  -o-transform: translate(-1020px);
  -moz-transform: translate(-1020px);
  -webkit-transform: translate3d(-1020px, 0, 0);
}
.slides > article.current {
  display: block;
  transform: translate(0);
  -o-transform: translate(0);
  -moz-transform: translate(0);
  -webkit-transform: translate3d(0, 0, 0);
}
.slides > article.next {
  display: block;
  transform: translate(1020px);
  -o-transform: translate(1020px);
  -moz-transform: translate(1020px);
  -webkit-transform: translate3d(1020px, 0, 0);
}
.slides > article.far-next {
  display: block;
  transform: translate(2040px);
  -o-transform: translate(2040px);
  -moz-transform: translate(2040px);
  -webkit-transform: translate3d(2040px, 0, 0);
}

.slides.layout-widescreen > article.far-past,
.slides.layout-faux-widescreen > article.far-past {
  display: block;
  transform: translate(-2260px);
  -o-transform: translate(-2260px);
  -moz-transform: translate(-2260px);
  -webkit-transform: translate3d(-2260px, 0, 0);
}
.slides.layout-widescreen > article.past,
.slides.layout-faux-widescreen > article.past {
  display: block;
  transform: translate(-1130px);
  -o-transform: translate(-1130px);
  -moz-transform: translate(-1130px);
  -webkit-transform: translate3d(-1130px, 0, 0);
}
.slides.layout-widescreen > article.current,
.slides.layout-faux-widescreen > article.current {
  display: block;
  transform: translate(0);
  -o-transform: translate(0);
  -moz-transform: translate(0);
  -webkit-transform: translate3d(0, 0, 0);
}
.slides.layout-widescreen > article.next,
.slides.layout-faux-widescreen > article.next {
  display: block;
  transform: translate(1130px);
  -o-transform: translate(1130px);
  -moz-transform: translate(1130px);
  -webkit-transform: translate3d(1130px, 0, 0);
}
.slides.layout-widescreen > article.far-next,
.slides.layout-faux-widescreen > article.far-next {
  display: block;
  transform: translate(2260px);
  -o-transform: translate(2260px);
  -moz-transform: translate(2260px);
  -webkit-transform: translate3d(2260px, 0, 0);
}

/* Styles for slides */

.slides > article {
  font-family: 'Open Sans', Arial, sans-serif;

  color: rgb(102, 102, 102);
  text-shadow: 0 1px 1px rgba(0, 0, 0, .1);

  font-size: 30px;
  line-height: 36px;

  letter-spacing: -1px;
}

b {
  font-weight: 600;
}

.blue {
  color: rgb(0, 102, 204);
}
.yellow {
  color: rgb(255, 211, 25);
}
.green {
  color: rgb(0, 138, 53);
}
.red {
  color: rgb(255, 0, 0);
}
.black {
  color: black;
}
.white {
  color: white;
}

a {
  color: rgb(0, 102, 204);
}
a:visited {
  color: rgba(0, 102, 204, .75);
}
a:hover {
  color: black;
}

p {
  margin: 0;
  padding: 0;

  margin-top: 20px;
}
p:first-child {
  margin-top: 0;
}

h1 {
  font-size: 60px;
  line-height: 60px;

  padding: 0;
  margin: 0;
  margin-top: 200px;
  padding-right: 40px;

  font-weight: 600;

  letter-spacing: -3px;

  color: rgb(51, 51, 51);
}

h2 {
  font-size: 45px;
  line-height: 45px;

  position: absolute;
  bottom: 150px;

  padding: 0;
  margin: 0;
  padding-right: 40px;

  font-weight: 600;

  letter-spacing: -2px;

  color: rgb(51, 51, 51);
}

h3 {
  font-size: 30px;
  line-height: 36px;

  padding: 0;
  margin: 0;
  padding-right: 40px;

  font-weight: 600;

  letter-spacing: -1px;

  color: rgb(51, 51, 51);
}

article.fill h3 {
  background: rgba(255, 255, 255, .75);
  padding-top: .2em;
  padding-bottom: .3em;
  margin-top: -.2em;
  margin-left: -60px;
  padding-left: 60px;
  margin-right: -60px;
  padding-right: 60px;
}


iframe {
  width: 100%;

  height: 620px;

  background: white;
  border: 1px solid rgb(192, 192, 192);
  margin: -1px;
  /*box-shadow: inset 0 2px 6px rgba(0, 0, 0, .1);*/
}

h3 + iframe {
  margin-top: 40px;
  height: 540px;
}

article.fill iframe {
  position: absolute;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;

  border: 0;
  margin: 0;

  border-radius: 10px;
  -o-border-radius: 10px;
  -moz-border-radius: 10px;
  -webkit-border-radius: 10px;

  z-index: -1;
}

article.fill img {
  position: absolute;
  left: 0;
  top: 0;
  min-width: 100%;
  min-height: 100%;

  border-radius: 10px;
  -o-border-radius: 10px;
  -moz-border-radius: 10px;
  -webkit-border-radius: 10px;

  z-index: -1;
}
img.centered {
  margin: 0 auto;
  display: block;
}


div.author {
  text-align: right;  
  font-size: 40px;
  
  margin-top: 20px;
  margin-right: 150px;    
}
div.author::before {
  content: '—';
}

/* Builds */

.build > * {
  transition: opacity 0.5s ease-in-out 0.2s;
  -o-transition: opacity 0.5s ease-in-out 0.2s;
  -moz-transition: opacity 0.5s ease-in-out 0.2s;
  -webkit-transition: opacity 0.5s ease-in-out 0.2s;
}

.to-build {
  opacity: 0;
}


    
    
  </style>

  <body style='display: none'>

    <section class='slides layout-regular template-default'>
EOF
### HTML HEADER END ###

### HTML BODY START ###
ls -1 ./*.{jpg,png,gif,JPG,PNG,GIF} 2>/dev/null | while read p; do
	convert $p -resize 900x700 ./gllry/$p;
	echo "<article class='fill'><p><img src='$p'></p></article>" >> ./gllry/index.html
done
### HTML BODY END ###

### HTML FOOTER START ###
cat >> ./gllry/index.html << EOF
    </section>
  </body>
</html>
EOF
### HTML FOOTER END ###
