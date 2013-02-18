// Generated by CoffeeScript 1.4.0
/*

Copyright (c) 2012 Legwork Studio. All Rights Reserved. Your wife is hot.
*/

var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

Legwork.MobileMenu = (function() {
  /*
    *------------------------------------------*
    | constructor:void (-)
    |
    | Construct the fuggin' thing.
    *----------------------------------------
  */

  function MobileMenu() {
    this.onTouchEnd = __bind(this.onTouchEnd, this);

    this.onTouchMove = __bind(this.onTouchMove, this);

    this.onTouchStart = __bind(this.onTouchStart, this);
    this.$header = $('header');
    this.$nav = $('nav');
    this.$menu_btn = $('#menu-btn');
    this.initial_time = 0;
    this.initial_touch = 0;
    this.last_y = 0;
    this.direction = 'down';
    this.final_touch = 0;
    this.observeSomeSweetEvents();
  }

  /*
    *------------------------------------------*
    | observeSomeSweetEvents:void (-)
    |
    | Observe events scoped to this class.
    *----------------------------------------
  */


  MobileMenu.prototype.observeSomeSweetEvents = function() {
    this.touch_start = Modernizr.touch ? 'touchstart' : 'mousedown';
    this.touch_move = Modernizr.touch ? 'touchmove' : 'mousemove';
    this.touch_end = Modernizr.touch ? 'touchend' : 'mouseup';
    return this.$menu_btn[0].addEventListener(this.touch_start, this.onTouchStart, false);
  };

  /*
    *------------------------------------------*
    | onTouchStart:void (=)
    |
    | e:object - event object
    |
    | User has initiated a touch.
    *----------------------------------------
  */


  MobileMenu.prototype.onTouchStart = function(e) {
    e.preventDefault();
    this.initial_time = new Date().getTime();
    this.initial_touch = e.touches != null ? e.touches[0].pageY - (this.$menu_btn.offset().top - Legwork.$wn.scrollTop()) : e.pageY - this.$menu_btn.offset().top;
    this.$header.removeClass('transition');
    Legwork.$wrapper[0].addEventListener(this.touch_move, this.onTouchMove, false);
    return Legwork.$wrapper[0].addEventListener(this.touch_end, this.onTouchEnd, false);
  };

  /*
    *------------------------------------------*
    | onTouchMove:void (=)
    |
    | e:object - event object
    |
    | User is finger blasting the device.
    *----------------------------------------
  */


  MobileMenu.prototype.onTouchMove = function(e) {
    var offset, y;
    e.preventDefault();
    y = e.touches != null ? e.touches[0].pageY : e.pageY;
    offset = y - this.initial_touch > 0 ? y - this.initial_touch : 0;
    this.direction = y > this.last_y ? 'down' : 'up';
    this.last_y = y;
    if (new Date().getTime() - this.initial_time < 220) {
      return false;
    } else {
      return this.$header.css('margin-top', offset + 'px');
    }
  };

  /*
    *------------------------------------------*
    | onTouchEnd:void (=)
    |
    | e:object - event object
    |
    | User has let 'er go.
    *----------------------------------------
  */


  MobileMenu.prototype.onTouchEnd = function(e) {
    Legwork.$wrapper[0].removeEventListener(this.touch_move, this.onTouchMove, false);
    Legwork.$wrapper[0].removeEventListener(this.touch_end, this.onTouchEnd, false);
    this.final_touch = e.changedTouches != null ? e.changedTouches[0].pageY : e.pageY;
    if (this.final_touch - this.initial_touch > this.$nav.outerHeight()) {
      return this.$header.addClass('transition open').css('margin-top', this.$nav.outerHeight() + 'px');
    } else {
      if (this.initial_touch === this.final_touch) {
        this.direction = 'down';
      } else if (this.initial_touch === this.final_touch - this.$nav.outerHeight()) {
        this.direction = 'up';
      }
      if (this.direction === 'up') {
        return this.$header.removeClass('open').addClass('transition').css('margin-top', '0px');
      } else if (this.direction === 'down') {
        return this.$header.addClass('transition open').css('margin-top', this.$nav.outerHeight() + 'px');
      }
    }
  };

  /*
    *------------------------------------------*
    | resetHeader:void (-)
    |
    | Reset header when app layout changes.
    *----------------------------------------
  */


  MobileMenu.prototype.resetHeader = function() {
    this.$header.removeClass('transition');
    if (this.$menu_btn.is(':visible') === true && this.$header.hasClass('open') === true) {
      return this.$header.css('margin-top', this.$nav.outerHeight() + 'px');
    } else {
      return this.$header.css('margin-top', '0px');
    }
  };

  return MobileMenu;

})();
