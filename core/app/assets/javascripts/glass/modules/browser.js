/**
 * Created by StefanS on 2015-Sept-17
 *  - JoeKrump had originally put this in main.js
 */

var GlassBrowser = (function ($) {
  function initBrowserDetermination() {
    $('.btn-anchor').removeAttr('disabled');
    // Check for desktop firefox
    var isFirefox = typeof InstallTrigger !== 'undefined';
    // check for mobile firefox.
    if(!isFirefox){
      isFirefox = navigator.platform.toLowerCase().indexOf("firefox") > -1;
    }

    if(isFirefox){
      $('body').addClass('mozilla');
    }
  }

  initBrowserDetermination();

  // Return API for other modules
  return {
  };
})(jQuery);
