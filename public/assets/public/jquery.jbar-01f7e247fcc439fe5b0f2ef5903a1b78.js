/*
 * jbar (for jQuery)
 * version: 0.2.0 (07/02/2011)
 * @requires jQuery v1.4 or later
 * http://javan.github.com/jbar/
 * http://github.com/javan/jbar
 *
 * Licensed under the MIT:
 *   http://www.opensource.org/licenses/mit-license.php
 *
 * Copyright 2010+ Javan Makhmali :: javan@javan.us
 *
 * Usage:
 *  
 *  jQuery(function(){
 *    jQuery('.jbar').jbar();
 *  });
 *  // Where .jbar is the class belonging to your menus.
 *
 */
(function(a){a.fn.jbar=function(b){var c={cssClass:"jbar",downArrow:"&#x25BC;",upArrow:"&#x25B2;",showSubmenuEvent:"click",fixIEzindex:!0};b&&a.extend(c,b),this.each(function(){var b=a(this);b.addClass(c.cssClass),a.browser.msie&&b.addClass("jbar_browser_IE").addClass("jbar_browser_IE"+parseInt(a.browser.version)),b.find("> li").each(function(){var b=a(this),d=b.find("ul"),e=b.find("> a"),f=d.length!=0,g=e.length!=0,h=g&&e.attr("href").charAt(0)=="#";g&&(e.wrapInner('<span class="link_text" />'),f||e.addClass("has_no_down_arrow"));if(!f)return!0;d.wrap('<div class="submenu_container" />'),b.find("div.submenu_container").prepend('<span class="up_arrow">'+c.upArrow+"</span>"),d.show(),g||(e=a('<a href="#" class="has_lonely_down_arrow"></a>'),h=!0,b.prepend(e)),e.addClass("has_down_arrow").append(' <span class="down_arrow"><em>'+c.downArrow+"</em></span>"),h?e.addClass("trigger"):(e.addClass("has_trigger_down_arrow").find(".link_text").mouseover(function(){a(this).addClass("hovered")}).mouseleave(function(){a(this).removeClass("hovered")}),e.find(".down_arrow").addClass("trigger").mouseover(function(){a(this).addClass("hovered")}).mouseleave(function(){a(this).removeClass("hovered")})),b.find(".trigger").live(c.showSubmenuEvent,function(c){c.preventDefault();var d=b.find(".submenu_container").outerWidth(),e=b.find(".down_arrow").position().left+2,f=e;e>d&&(f=d-20),b.find("span.up_arrow").css({paddingLeft:f+"px"}),b.find(".submenu_container").css({top:b.outerHeight()+"px"}).show(),a(this).addClass("triggered").addClass("hovered"),b.mouseleave(function(){b.find(".trigger").removeClass("triggered").removeClass("hovered"),b.find(".submenu_container").hide()})})}),a(this).find("> li:first a:first").addClass("first"),a(this).find("> li:last a:first").addClass("last")});if(c.fixIEzindex&&a.browser.msie&&a.browser.version<8){var d=99999;a("ul.jbar").each(function(){a(this).wrap('<div class="jbar_IE_zIndex_fix" style="z-index:'+d+'" />'),d--})}return this}})(jQuery)