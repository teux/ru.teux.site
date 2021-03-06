﻿$(function(){$("div#ltoc").hover(expandTOC,	function(){$(this).stop(true,false).animate({width:175},{"duration":"fast","easing":"swing"});});});
$(document).ready(function(){$("div#ltoc").css({overflow:"hidden"});});

function getContentWidth(obj) {
    var cWidth, cObj, width = 0;
    for (var i=0; i<obj.childNodes.length; i++){
        cObj = obj.childNodes[i];
        cWidth = 0;
        if (cObj.nodeName=="TABLE"){cWidth = cObj.clientWidth;}
        else if (cObj.nodeName=="DIV"){cWidth = getContentWidth(cObj);}
        if (cWidth > width) {width = cWidth}
    }
    return width;
}

function expandTOC(){
    var contentWidth = getContentWidth(document.getElementById("ltoc"));
    if(contentWidth>171){$(this).stop(true,false).css({zIndex:"99",position:"relative",overflow:"hidden"}).animate({width:contentWidth+"px"},{"duration":"fast","easing":"swing"});}
}

/* Function to hide/display a block object                                                       */
function fadeDIV(maintext, descr){
    var mtext = document.getElementById(maintext);
    var des = document.getElementById(descr);

    if(mtext.style.display == 'none'){
        des.style.display = 'none';
        //$(maintext).appear();
        //$(maintext).appear();
        mtext.style.display = 'block';
    }
    else{
        //Effect.SwitchOff(maintext);
        mtext.style.display = 'none';
        des.style.display = 'block';
        //$(descr).appear({ duration: 1.0 });
    }
}
// requestAnimationFrame polyfill
(function ($, window) {
    window.requestAnimationFrame = window.requestAnimationFrame ||
        window.webkitRequestAnimationFrame ||
        window.mozRequestAnimationFrame ||
        window.msRequestAnimationFrame ||
        window.oRequestAnimationFrame ||
        function (fCallback) {
            window.setTimeout(fCallback, 1e3 / 60);
        };
    window.cancelAnimationFrame = window.cancelAnimationFrame ||
        window.webkitCancelAnimationFrame ||
        window.mozCancelAnimationFrame ||
        window.msCancelAnimationFrame ||
        window.oCancelAnimationFrame ||
        function (requestID) {
            window.clearTimeout(requestID);
        };
})(jQuery, window);

// Parallax slot for maps
(function ($, window) {
    "use strict";
    var jWindow = $(window);
    var jDoc = $(document);
    /**
     * Создает блок с эффектом параллакса.
     * @param {Object} opts
     * @constructor
     */
    function ParallaxBlock(opts) {
        if (!(this instanceof ParallaxBlock)) {
            return new ParallaxBlock(opts);
        }
        this.bounds = {};
        for (var name in opts) {
            if (this[name] === undefined) {
                this[name] = opts[name];
            }
        }
        jWindow.bind('scroll', this.onScroll.bind(this));
        // Пеориодическая проверка изменения размеров окна (disqus)
        window.setInterval(function () {
            if (this.bounds.windowHeight !== jWindow.height()
                || this.bounds.docHeight !== jDoc.height()) {
                this.repaint();
            }
        }.bind(this), 300);
    }
    ParallaxBlock.prototype.repaint = function () {
        this.bounds = this.recalcBounds();
        this.onScroll();
    };
    ParallaxBlock.prototype.recalcBounds = function () {
        var elemTop = this.elem.offset().top;
        var elemHeight = this.elem.height();
        var windowHeight = jWindow.height();
        var docHeight = jDoc.height();
        var bounds = {
            min: Math.max(elemTop - windowHeight, 0),
            max: Math.min(elemTop + elemHeight, Math.max(docHeight - windowHeight, 0)),
            docHeight: docHeight,
            windowHeight: windowHeight
        };
        bounds.range = bounds.max - bounds.min;
        return bounds;
    };
    ParallaxBlock.prototype.onScroll = function () {
        var scroll, portion, k;
        if (this.preventRepaint) {
            return;
        }
        scroll = jWindow.scrollTop();
        portion = this.slowdown ?
        this.bounds.max - scroll :
        scroll - this.bounds.min;
        if (this.bounds.range) {
            k = portion / this.bounds.range;
        } else if (this.slowdown) {
            k = 1;
        }
        if (k >= 0 && k <= 1 && k !== this.bounds.k) {
            this.bounds.k = k;
            this.preventRepaint = true;
            requestAnimationFrame(function () {
                this.bgImg.css('bottom', this.maxScroll * k - this.maxScroll);
                this.preventRepaint = false;
            }.bind(this));
        }
    };
    $(function () {
        $('.js-module, [data-module*="Parallax"]').each(function (i, elem) {
            elem = $(elem);
            window.addEventListener('load', function () {
                var bgImg = elem.find('.parallax--bg-image');
                var opts = {
                    elem: elem,
                    bgImg: bgImg,
                    maxScroll: bgImg.height() - elem.height(),
                    slowdown: elem.attr('data-slowdown') === 'true'
                };
                ParallaxBlock(opts);
            });
        });
    });
})(jQuery, window);
