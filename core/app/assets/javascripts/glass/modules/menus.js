/**
 * Created by StefanS on 2014-Dec-10
 */

var GlassMenus = (function ($) {
  $(document).on('content-ready', function (e, element) {

    var $cmsLeftSidebar = $('#sidebar-left').first();
    var $cmsRightSidebar = $('#sidebar-right').first();
    var $toggleCMSMenuButton = $('#toggle-cms-menu');
    var $closeBtn = $('.close-cms-menu');
    var sidebar_settings = {
      onVisible : function() { showSidebar(); },
      onHide    : function() { hideSidebar(); }
    };

    // set callback listeners for semantic-ui sidebars that cause the no-scroll class to be toggled.
    //
    if($cmsLeftSidebar){
      $closeBtn.click(function(e){
        e.preventDefault();
        $cmsLeftSidebar.removeClass('sidebar-open');
      });

      $toggleCMSMenuButton.unbind('click').click(function(e){
        e.preventDefault();
        $cmsLeftSidebar.toggleClass('sidebar-open');
      });

      $cmsLeftSidebar.sidebar( 'attach events', '.sidebar-left-opener',  'overlay', 'show').sidebar('setting', sidebar_settings);
    }

    if($cmsRightSidebar){
      $cmsRightSidebar.sidebar('attach events', '.sidebar-right-opener', 'overlay', 'show').sidebar('setting', sidebar_settings);
    }

  });

  function hideSidebar() {
    $('html').removeClass('no-scroll');
  }

  function showSidebar() {
    $('html').addClass('no-scroll');
  }

  // Return API for other modules
  return {
    hideSidebar: hideSidebar,
    showSidebar: showSidebar
  };
})(jQuery);
