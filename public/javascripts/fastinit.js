/*
*
* Copyright (c) 2007 Andrew Tetlaw
* 
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without
* restriction, including without limitation the rights to use, copy,
* modify, merge, publish, distribute, sublicense, and/or sell copies
* of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
* BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
* ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
* CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
* * 
*
*
* FastInit
* http://tetlaw.id.au/view/javascript/fastinit
* Andrew Tetlaw
* Version 1.4.1 (2007-03-15)
* Based on:
* http://dean.edwards.name/weblog/2006/03/faster
* http://dean.edwards.name/weblog/2006/06/again/
* Help from:
* http://www.cherny.com/webdev/26/domloaded-object-literal-updated
* 
*/
var FastInit = {
	onload : function() {
		if (FastInit.done) { return; }
		FastInit.done = true;
		for(var x = 0, al = FastInit.f.length; x < al; x++) {
			FastInit.f[x]();
		}
	},
	addOnLoad : function() {
		var a = arguments;
		for(var x = 0, al = a.length; x < al; x++) {
			if(typeof a[x] === 'function') {
				if (FastInit.done ) {
					a[x]();
				} else {
					FastInit.f.push(a[x]);
				}
			}
		}
	},
	listen : function() {
		if (/WebKit|khtml/i.test(navigator.userAgent)) {
			FastInit.timer = setInterval(function() {
				if (/loaded|complete/.test(document.readyState)) {
					clearInterval(FastInit.timer);
					delete FastInit.timer;
					FastInit.onload();
				}}, 10);
		} else if (document.addEventListener) {
			document.addEventListener('DOMContentLoaded', FastInit.onload, false);
		} else if(!FastInit.iew32) {
			if(window.addEventListener) {
				window.addEventListener('load', FastInit.onload, false);
			} else if (window.attachEvent) {
				return window.attachEvent('onload', FastInit.onload);
			}
		}
	},
	f:[],done:false,timer:null,iew32:false
};
/*@cc_on @*/
/*@if (@_win32)
FastInit.iew32 = true;
document.write('<script id="__ie_onload" defer src="' + ((location.protocol == 'https:') ? '//0' : 'javascript:void(0)') + '"><\/script>');
document.getElementById('__ie_onload').onreadystatechange = function(){if (this.readyState == 'complete') { FastInit.onload(); }};
/*@end @*/
FastInit.listen();