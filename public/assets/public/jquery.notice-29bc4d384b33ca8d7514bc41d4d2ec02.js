/**
*	jQuery.noticeAdd() and jQuery.noticeRemove()
*	These functions create and remove growl-like notices
*		
*   Copyright (c) 2009 Tim Benniks
*
*	Permission is hereby granted, free of charge, to any person obtaining a copy
*	of this software and associated documentation files (the "Software"), to deal
*	in the Software without restriction, including without limitation the rights
*	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
*	copies of the Software, and to permit persons to whom the Software is
*	furnished to do so, subject to the following conditions:
*
*	The above copyright notice and this permission notice shall be included in
*	all copies or substantial portions of the Software.
*
*	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
*	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
*	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
*	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
*	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
*	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
*	THE SOFTWARE.
*	
*	@author 	Tim Benniks <tim@timbenniks.com>
* 	@copyright  2009 timbenniks.com
*	@version    $Id: jquery.notice.js 1 2009-01-24 12:24:18Z timbenniks $
**/
(function(a){a.extend({noticeAdd:function(b){var c={inEffect:{opacity:"show"},inEffectDuration:600,stayTime:3e3,text:"",stay:!1,type:"notice"},b,d,e,f,g;b=a.extend({},c,b),d=a(".notice-wrap").length?a(".notice-wrap"):a("<div></div>").addClass("notice-wrap").appendTo("body"),e=a("<div></div>").addClass("notice-item-wrapper"),f=a("<div></div>").hide().addClass("notice-item "+b.type).appendTo(d).html("<p>"+b.text+"</p>").animate(b.inEffect,b.inEffectDuration).wrap(e),g=a("<div></div>").addClass("notice-item-close").prependTo(f).html("x").click(function(){a.noticeRemove(f)}),navigator.userAgent.match(/MSIE 6/i)&&d.css({top:document.documentElement.scrollTop}),b.stay||setTimeout(function(){a.noticeRemove(f)},b.stayTime)},noticeRemove:function(a){a.animate({opacity:"0"},600,function(){a.parent().animate({height:"0px"},300,function(){a.parent().remove()})})}})})(jQuery)