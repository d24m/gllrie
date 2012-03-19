#!/bin/bash
# This Project based upon html5slides (http://code.google.com/p/html5slides/)
# For more information please visit http://github.com/d24m/gllrie

mkdir -p gllrie
### HTML HEADER START ###
cat > ./gllrie/index.html << EOF 
<!DOCTYPE html>

<!--
  gllrie - Bash-Script for creating a simple web-gallery
  based on html5slides (http://code.google.com/p/html5slides/)
  For more information please visit http://github.com/d24m/gllrie

  Original: template/index.html
  Google HTML5 slide template

  Authors: Luke Mahé (code)
           Marcin Wichary (code and design)
           
           Dominic Mazzoni (browser compatibility)
           Charles Chen (ChromeVox support)

  URL: http://code.google.com/p/html5slides/
  
  Changes: Changed title to gllrie and insert slides.js and styles.css
-->

<html>
  <head>
    <title>gllrie</title>

    <meta charset='utf-8'>
    <script>
      /*
  
  Original: slides.js
  Google HTML5 slides template

  Authors: Luke Mahé (code)
           Marcin Wichary (code and design)

           Dominic Mazzoni (browser compatibility)
           Charles Chen (ChromeVox support)

  URL: http://code.google.com/p/html5slides/

  Changes: Removed unnecessary functions and optimized size with yuicompressor (http://developer.yahoo.com/yui/compressor)
*/
var SLIDE_CLASSES=["far-past","past","current","next","far-next"];var PM_TOUCH_SENSITIVITY=15;var curSlide;if(typeof document!=="undefined"&&!("classList" in document.createElement("a"))){(function(a){var f="classList",d="prototype",e=(a.HTMLElement||a.Element)[d],g=Object;strTrim=String[d].trim||function(){return this.replace(/^\s+|\s+$/g,"")},arrIndexOf=Array[d].indexOf||function(k){for(var j=0,h=this.length;j<h;j++){if(j in this&&this[j]===k){return j}}return -1},DOMEx=function(h,i){this.name=h;this.code=DOMException[h];this.message=i},checkTokenAndGetIndex=function(i,h){if(h===""){throw new DOMEx("SYNTAX_ERR","An invalid or illegal string was specified")}if(/\s/.test(h)){throw new DOMEx("INVALID_CHARACTER_ERR","String contains an invalid character")}return arrIndexOf.call(i,h)},ClassList=function(m){var l=strTrim.call(m.className),k=l?l.split(/\s+/):[];for(var j=0,h=k.length;j<h;j++){this.push(k[j])}this._updateClassName=function(){m.className=this.toString()}},classListProto=ClassList[d]=[],classListGetter=function(){return new ClassList(this)};DOMEx[d]=Error[d];classListProto.item=function(h){return this[h]||null};classListProto.contains=function(h){h+="";return checkTokenAndGetIndex(this,h)!==-1};classListProto.add=function(h){h+="";if(checkTokenAndGetIndex(this,h)===-1){this.push(h);this._updateClassName()}};classListProto.remove=function(i){i+="";var h=checkTokenAndGetIndex(this,i);if(h!==-1){this.splice(h,1);this._updateClassName()}};classListProto.toggle=function(h){h+="";if(checkTokenAndGetIndex(this,h)===-1){this.add(h)}else{this.remove(h)}};classListProto.toString=function(){return this.join(" ")};if(g.defineProperty){var c={get:classListGetter,enumerable:true,configurable:true};try{g.defineProperty(e,f,c)}catch(b){if(b.number===-2146823252){c.enumerable=false;g.defineProperty(e,f,c)}}}else{if(g[d].__defineGetter__){e.__defineGetter__(f,classListGetter)}}}(self))}function getSlideEl(a){if((a<0)||(a>=slideEls.length)){return null}else{return slideEls[a]}}function updateSlideClass(a,d){var c=getSlideEl(a);if(!c){return}if(d){c.classList.add(d)}for(var b in SLIDE_CLASSES){if(d!=SLIDE_CLASSES[b]){c.classList.remove(SLIDE_CLASSES[b])}}}function updateSlides(){for(var a=0;a<slideEls.length;a++){switch(a){case curSlide-2:updateSlideClass(a,"far-past");break;case curSlide-1:updateSlideClass(a,"past");break;case curSlide:updateSlideClass(a,"current");break;case curSlide+1:updateSlideClass(a,"next");break;case curSlide+2:updateSlideClass(a,"far-next");break;default:updateSlideClass(a);break}}triggerLeaveEvent(curSlide-1);triggerEnterEvent(curSlide);window.setTimeout(function(){disableSlideFrames(curSlide-2)},301);enableSlideFrames(curSlide-1);enableSlideFrames(curSlide+2);if(isChromeVoxActive()){speakAndSyncToNode(slideEls[curSlide])}updateHash()}function buildNextItem(){var a=slideEls[curSlide].querySelectorAll(".to-build");if(!a.length){return false}a[0].classList.remove("to-build","");if(isChromeVoxActive()){speakAndSyncToNode(a[0])}return true}function prevSlide(){if(curSlide>0){curSlide--;updateSlides()}}function nextSlide(){if(buildNextItem()){return}if(curSlide<slideEls.length-1){curSlide++;updateSlides()}}function triggerEnterEvent(d){var c=getSlideEl(d);if(!c){return}var b=c.getAttribute("onslideenter");if(b){new Function(b).call(c)}var a=document.createEvent("Event");a.initEvent("slideenter",true,true);a.slideNumber=d+1;c.dispatchEvent(a)}function triggerLeaveEvent(d){var b=getSlideEl(d);if(!b){return}var c=b.getAttribute("onslideleave");if(c){new Function(c).call(b)}var a=document.createEvent("Event");a.initEvent("slideleave",true,true);a.slideNumber=d+1;b.dispatchEvent(a)}function handleTouchStart(a){if(a.touches.length==1){touchDX=0;touchDY=0;touchStartX=a.touches[0].pageX;touchStartY=a.touches[0].pageY;document.body.addEventListener("touchmove",handleTouchMove,true);document.body.addEventListener("touchend",handleTouchEnd,true)}}function handleTouchMove(a){if(a.touches.length>1){cancelTouch()}else{touchDX=a.touches[0].pageX-touchStartX;touchDY=a.touches[0].pageY-touchStartY}}function handleTouchEnd(c){var b=Math.abs(touchDX);var a=Math.abs(touchDY);if((b>PM_TOUCH_SENSITIVITY)&&(a<(b*2/3))){if(touchDX>0){prevSlide()}else{nextSlide()}}cancelTouch()}function cancelTouch(){document.body.removeEventListener("touchmove",handleTouchMove,true);document.body.removeEventListener("touchend",handleTouchEnd,true)}function disableSlideFrames(e){var b=getSlideEl(e);if(!b){return}var d=b.getElementsByTagName("iframe");for(var a=0,c;c=d[a];a++){disableFrame(c)}}function enableSlideFrames(e){var b=getSlideEl(e);if(!b){return}var d=b.getElementsByTagName("iframe");for(var a=0,c;c=d[a];a++){enableFrame(c)}}function disableFrame(a){a.src="about:blank"}function enableFrame(b){var a=b._src;if(b.src!=a&&a!="about:blank"){b.src=a}}function setupFrames(){var c=document.querySelectorAll("iframe");for(var a=0,b;b=c[a];a++){b._src=b.src;disableFrame(b)}enableSlideFrames(curSlide);enableSlideFrames(curSlide+1);enableSlideFrames(curSlide+2)}function setupInteraction(){var a=document.createElement("div");a.className="slide-area";a.id="prev-slide-area";a.addEventListener("click",prevSlide,false);document.querySelector("section.slides").appendChild(a);var a=document.createElement("div");a.className="slide-area";a.id="next-slide-area";a.addEventListener("click",nextSlide,false);document.querySelector("section.slides").appendChild(a);document.body.addEventListener("touchstart",handleTouchStart,false)}function isChromeVoxActive(){if(typeof(cvox)=="undefined"){return false}else{return true}}function speakAndSyncToNode(a){if(!isChromeVoxActive()){return}cvox.ChromeVox.navigationManager.switchToStrategy(cvox.ChromeVoxNavigationManager.STRATEGIES.LINEARDOM,0,true);cvox.ChromeVox.navigationManager.syncToNode(a);cvox.ChromeVoxUserCommands.finishNavCommand("");var b=a;while(b.firstChild){b=b.firstChild}cvox.ChromeVox.navigationManager.syncToNode(b)}function speakNextItem(){if(!isChromeVoxActive()){return}cvox.ChromeVox.navigationManager.switchToStrategy(cvox.ChromeVoxNavigationManager.STRATEGIES.LINEARDOM,0,true);cvox.ChromeVox.navigationManager.next(true);if(!cvox.DomUtil.isDescendantOfNode(cvox.ChromeVox.navigationManager.getCurrentNode(),slideEls[curSlide])){var a=slideEls[curSlide];while(a.firstChild){a=a.firstChild}cvox.ChromeVox.navigationManager.syncToNode(a);cvox.ChromeVox.navigationManager.next(true)}cvox.ChromeVoxUserCommands.finishNavCommand("")}function speakPrevItem(){if(!isChromeVoxActive()){return}cvox.ChromeVox.navigationManager.switchToStrategy(cvox.ChromeVoxNavigationManager.STRATEGIES.LINEARDOM,0,true);cvox.ChromeVox.navigationManager.previous(true);if(!cvox.DomUtil.isDescendantOfNode(cvox.ChromeVox.navigationManager.getCurrentNode(),slideEls[curSlide])){var a=slideEls[curSlide];while(a.lastChild){a=a.lastChild}cvox.ChromeVox.navigationManager.syncToNode(a);cvox.ChromeVox.navigationManager.previous(true)}cvox.ChromeVoxUserCommands.finishNavCommand("")}function getCurSlideFromHash(){var a=parseInt(location.hash.substr(1));if(a){curSlide=a-1}else{curSlide=0}}function updateHash(){location.replace("#"+(curSlide+1))}function handleBodyKeyDown(a){switch(a.keyCode){case 39:case 13:case 32:case 34:nextSlide();a.preventDefault();break;case 37:case 8:case 33:prevSlide();a.preventDefault();break;case 40:if(isChromeVoxActive()){speakNextItem()}else{nextSlide()}a.preventDefault();break;case 38:if(isChromeVoxActive()){speakPrevItem()}else{prevSlide()}a.preventDefault();break}}function addEventListeners(){document.addEventListener("keydown",handleBodyKeyDown,false)}function addFontStyle(){var a=document.createElement("link");a.rel="stylesheet";a.type="text/css";a.href="http://fonts.googleapis.com/css?family=Open+Sans:regular,semibold,italic,italicsemibold|Droid+Sans+Mono";document.body.appendChild(a)}function addGeneralStyle(){var a=document.createElement("meta");a.name="viewport";a.content="width=1100,height=750";document.querySelector("head").appendChild(a);var a=document.createElement("meta");a.name="apple-mobile-web-app-capable";a.content="yes";document.querySelector("head").appendChild(a)}function makeBuildLists(){for(var d=curSlide,a;a=slideEls[d];d++){var b=a.querySelectorAll(".build > *");for(var c=0,e;e=b[c];c++){if(e.classList){e.classList.add("to-build")}}}}function handleDomLoaded(){slideEls=document.querySelectorAll("section.slides > article");setupFrames();addFontStyle();addGeneralStyle();addEventListeners();updateSlides();setupInteraction();makeBuildLists();document.body.classList.add("loaded")}function initialize(){getCurSlideFromHash();if(window._DCL){handleDomLoaded()}else{document.addEventListener("DOMContentLoaded",handleDomLoaded,false)}}initialize();

</script>


  </head>
  
  <style>
    /*
  Original: styles.css
  Google HTML5 slides template

  Authors: Luke Mahé (code)
           Marcin Wichary (code and design)
           
           Dominic Mazzoni (browser compatibility)
           Charles Chen (ChromeVox support)

  URL: http://code.google.com/p/html5slides/

  Changes: Removed unnecessary selectors and optimized size with yuicompressor (http://developer.yahoo.com/yui/compressor)
*/

html{height:100%}body{margin:0;padding:0;display:block!important;height:100%;min-height:740px;overflow-x:hidden;overflow-y:auto;background:#d7d7d7;background:-o-radial-gradient(#f0f0f0,#bebebe);background:-moz-radial-gradient(#f0f0f0,#bebebe);background:-webkit-radial-gradient(#f0f0f0,#bebebe);background:-webkit-gradient(radial,50% 50%,0,50% 50%,500,from(#f0f0f0),to(#bebebe));-webkit-font-smoothing:antialiased}.slides{width:100%;height:100%;left:0;top:0;position:absolute;-webkit-transform:translate3d(0,0,0)}.slides>article{display:block;position:absolute;overflow:hidden;width:900px;height:700px;left:50%;top:50%;margin-left:-450px;margin-top:-350px;padding:40px 60px;box-sizing:border-box;-o-box-sizing:border-box;-moz-box-sizing:border-box;-webkit-box-sizing:border-box;border-radius:10px;-o-border-radius:10px;-moz-border-radius:10px;-webkit-border-radius:10px;background-color:white;box-shadow:0 2px 6px rgba(0,0,0,.1);border:1px solid rgba(0,0,0,.3);transition:transform .3s ease-out;-o-transition:-o-transform .3s ease-out;-moz-transition:-moz-transform .3s ease-out;-webkit-transition:-webkit-transform .3s ease-out}.slides.layout-widescreen>article{margin-left:-550px;width:1100px}.slides.layout-faux-widescreen>article{margin-left:-550px;width:1100px;padding:40px 160px}.slides.template-default>article:not(.nobackground):not(.biglogo){background:url(images/google-logo-small.png) 710px 625px no-repeat;background-color:white}.slides.template-io2011>article:not(.nobackground):not(.biglogo){background:url(images/colorbar.png) 0 600px repeat-x,url(images/googleio-logo.png) 640px 625px no-repeat;background-size:100%,225px;background-color:white}.slides.layout-widescreen>article:not(.nobackground):not(.biglogo),.slides.layout-faux-widescreen>article:not(.nobackground):not(.biglogo){background-position-x:0,840px}.slide-area{z-index:1000;position:absolute;left:0;top:0;width:150px;height:700px;left:50%;top:50%;cursor:pointer;margin-top:-350px;tap-highlight-color:transparent;-o-tap-highlight-color:transparent;-moz-tap-highlight-color:transparent;-webkit-tap-highlight-color:transparent}.slides.layout-widescreen #prev-slide-area,.slides.layout-faux-widescreen #prev-slide-area{margin-left:-650px}.slides.layout-widescreen #next-slide-area,.slides.layout-faux-widescreen #next-slide-area{margin-left:500px}.slides>article{display:none}.slides>article.far-past{display:block;transform:translate(-2040px);-o-transform:translate(-2040px);-moz-transform:translate(-2040px);-webkit-transform:translate3d(-2040px,0,0)}.slides>article.past{display:block;transform:translate(-1020px);-o-transform:translate(-1020px);-moz-transform:translate(-1020px);-webkit-transform:translate3d(-1020px,0,0)}.slides>article.current{display:block;transform:translate(0);-o-transform:translate(0);-moz-transform:translate(0);-webkit-transform:translate3d(0,0,0)}.slides>article.next{display:block;transform:translate(1020px);-o-transform:translate(1020px);-moz-transform:translate(1020px);-webkit-transform:translate3d(1020px,0,0)}.slides>article.far-next{display:block;transform:translate(2040px);-o-transform:translate(2040px);-moz-transform:translate(2040px);-webkit-transform:translate3d(2040px,0,0)}.slides.layout-widescreen>article.far-past,.slides.layout-faux-widescreen>article.far-past{display:block;transform:translate(-2260px);-o-transform:translate(-2260px);-moz-transform:translate(-2260px);-webkit-transform:translate3d(-2260px,0,0)}.slides.layout-widescreen>article.past,.slides.layout-faux-widescreen>article.past{display:block;transform:translate(-1130px);-o-transform:translate(-1130px);-moz-transform:translate(-1130px);-webkit-transform:translate3d(-1130px,0,0)}.slides.layout-widescreen>article.current,.slides.layout-faux-widescreen>article.current{display:block;transform:translate(0);-o-transform:translate(0);-moz-transform:translate(0);-webkit-transform:translate3d(0,0,0)}.slides.layout-widescreen>article.next,.slides.layout-faux-widescreen>article.next{display:block;transform:translate(1130px);-o-transform:translate(1130px);-moz-transform:translate(1130px);-webkit-transform:translate3d(1130px,0,0)}.slides.layout-widescreen>article.far-next,.slides.layout-faux-widescreen>article.far-next{display:block;transform:translate(2260px);-o-transform:translate(2260px);-moz-transform:translate(2260px);-webkit-transform:translate3d(2260px,0,0)}.slides>article{font-family:'Open Sans',Arial,sans-serif;color:#666;text-shadow:0 1px 1px rgba(0,0,0,.1);font-size:30px;line-height:36px;letter-spacing:-1px}b{font-weight:600}.blue{color:#06c}.yellow{color:#ffd319}.green{color:#008a35}.red{color:#f00}.black{color:black}.white{color:white}a{color:#06c}a:visited{color:rgba(0,102,204,.75)}a:hover{color:black}p{margin:0;padding:0;margin-top:20px}p:first-child{margin-top:0}h1{font-size:60px;line-height:60px;padding:0;margin:0;margin-top:200px;padding-right:40px;font-weight:600;letter-spacing:-3px;color:#333}h2{font-size:45px;line-height:45px;position:absolute;bottom:150px;padding:0;margin:0;padding-right:40px;font-weight:600;letter-spacing:-2px;color:#333}h3{font-size:30px;line-height:36px;padding:0;margin:0;padding-right:40px;font-weight:600;letter-spacing:-1px;color:#333}article.fill h3{background:rgba(255,255,255,.75);padding-top:.2em;padding-bottom:.3em;margin-top:-.2em;margin-left:-60px;padding-left:60px;margin-right:-60px;padding-right:60px}iframe{width:100%;height:620px;background:white;border:1px solid #c0c0c0;margin:-1px}h3+iframe{margin-top:40px;height:540px}article.fill iframe{position:absolute;left:0;top:0;width:100%;height:100%;border:0;margin:0;border-radius:10px;-o-border-radius:10px;-moz-border-radius:10px;-webkit-border-radius:10px;z-index:-1}article.fill img{position:absolute;left:0;top:0;min-width:100%;min-height:100%;border-radius:10px;-o-border-radius:10px;-moz-border-radius:10px;-webkit-border-radius:10px;z-index:-1}img.centered{margin:0 auto;display:block}div.author{text-align:right;font-size:40px;margin-top:20px;margin-right:150px}div.author::before{content:'—'}.build>*{transition:opacity .5s ease-in-out .2s;-o-transition:opacity .5s ease-in-out .2s;-moz-transition:opacity .5s ease-in-out .2s;-webkit-transition:opacity .5s ease-in-out .2s}.to-build{opacity:0}
    
  </style>

  <body style='display: none'>

    <section class='slides layout-regular template-default'>
EOF
### HTML HEADER END ###

### HTML BODY START ###
ls -1 ./*.{jpg,png,gif,JPG,PNG,GIF} 2>/dev/null | while read p; do
	convert $p -resize 900x700 ./gllrie/$p;
	echo "<article class='fill'><p><img src='$p'></p></article>" >> ./gllrie/index.html
done
### HTML BODY END ###

### HTML FOOTER START ###
cat >> ./gllrie/index.html << EOF
    </section>
  </body>
</html>
EOF
### HTML FOOTER END ###
