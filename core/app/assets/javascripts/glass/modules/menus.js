/**
 * Created by StefanS on 2014-Dec-10
 */

var GlassMenus = (function ($) {
  $(document).on('content-ready', function (e, element) {

    var $cmsLeftSidebar = $('#sidebar-left').first();
    var $cmsRightSidebar = $('#sidebar-right').first();
    var $toggleCMSMenuButton = $('#toggle-cms-menu');

    var $closeBtn = $('.close-cms-menu');
    $closeBtn.click(function(e){
      e.preventDefault();
      $cmsLeftSidebar.removeClass('sidebar-open');
    });

    $toggleCMSMenuButton.unbind('click').click(function(e){
      e.preventDefault();
      $cmsLeftSidebar.toggleClass('sidebar-open');
    });

    // set callback listeners for semantic-ui sidebars that cause the no-scroll class to be toggled.
    $cmsLeftSidebar.sidebar('attach events', '.sidebar-left-opener', 'overlay', 'show')
      .sidebar('setting', {
        onVisible : function(){
          showSidebar();
        },
        onHide : function(){
          hideSidebar();
        }
      });

    $cmsRightSidebar.sidebar('attach events', '.sidebar-right-opener', 'overlay', 'show')
      .sidebar('setting', {
        onVisible : function(){
          showSidebar();
        },
        onHide : function(){
          hideSidebar();
        }
      });

    $(element).find('.sidebar-left-opener').click(function (e) {
      e.preventDefault();
    });
    $(element).find('.sidebar-right-opener').click(function (e) {
      e.preventDefault();
    });

  });

  function hideSidebar(){
    var wrapperDiv = $('#wrapper');
    if(wrapperDiv.length == 0){
      wrapperDiv = $('.pusher').first();
    }
    var top = wrapperDiv.css('top');

    wrapperDiv.css({top : '0px'}).removeClass('no-scroll');
    $('body').scrollTop(top.slice(1,-2));
  }

  function showSidebar(){
    var wrapperDiv = $('#wrapper');
    var $body = $('body');
    var topAmt = '-' + $body.scrollTop() + 'px';

    if(wrapperDiv.length == 0){
      wrapperDiv = $('.pusher').first();
    }

    wrapperDiv.css({top : topAmt}).addClass('no-scroll');
  }

  // Return API for other modules
  return {
    hideSidebar: hideSidebar,
    showSidebar: showSidebar
  };
})(jQuery);
