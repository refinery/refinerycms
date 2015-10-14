/**
 * Created by StefanS on 2014-Dec-10
 */

var GlassMenus = (function ($) {
  var cms_sidebars = [];

  $(document).on('content-ready', function (e, element) {
    $.each(cms_sidebars, function (i, val) {
      initButton(val.sidebar, val.button_selector, val.on_change, element);
    });

    GlassDimmer.getAllDimmers(element).on('click', function(e) {
      if ($(this).hasClass('dimmed')) {
        hideSidebar($('.sidebar.active'));
      }
    });
  });

  var $cmsLeftSidebar = $('#sidebar-left');
  var $cmsRightSidebar = $('#sidebar-right');

  if($cmsLeftSidebar.length > 0){
    initSidebar($cmsLeftSidebar, '.sidebar-left-opener');
  }

  if($cmsRightSidebar.length > 0) {
    initSidebar($cmsRightSidebar, '.sidebar-right-opener');
  }

  function hideSidebar($sidebar) {
    $sidebar.removeClass('active');
    $('html').removeClass('no-scroll');
    GlassDimmer.unDim();
  }

  function initSidebar($sidebar, button_selector, on_change_state) {
    cms_sidebars.push({button_selector: button_selector, sidebar: $sidebar, on_change: on_change_state});
    initButton($sidebar, button_selector, on_change_state, 'body');
  }

  function initButton($sidebar, button_selector, on_change_state, element) {
    $(element).find(button_selector).each(function () {
      if (!$(this).data('initialized')) {
        $(this).data('initialized', true);
        $(this).click(function (e) {
          if ($sidebar.hasClass('active')) {
            hideSidebar($sidebar);
          }
          else {
            $sidebar.addClass('active');
            $('html').addClass('no-scroll');
            setTimeout(function(){
              GlassDimmer.dim();
            }, 200);
          }
          if (on_change_state !== undefined) {
            on_change_state($sidebar, $sidebar.hasClass('active'));
          }
        });
      }
    });
  }

  // Return API for other modules
  return {
    initSidebar : initSidebar
  };
})(jQuery);
