/**
 * Created by StefanS on 2015-Feb-03
 */

var GlassAjaxReloads = (function ($) {
  $(document).on('content-ready', function (e, element) {
    //$(element).find('#sidebar-left-inner a').click(function (e) {
    //  e.preventDefault();
    //  $('#sidebar-left-inner a').removeClass('active');
    //  $(this).addClass('active');
    //  ajaxUpdate($(this).attr('href'), '#wrapper');
    //});
  });

  function ajaxUpdate(url, selector) {
    var $to_update = $(selector);
    $to_update.wrap("<div></div>");
    var $tmp = $to_update.parent();
    $tmp.fadeOut();
    $tmp.load(url + ' ' + selector, function () {
      $tmp.hide();
      $(document).trigger('content-ready', $tmp);
      $tmp.fadeIn(function () {
        $tmp.find(selector).first().unwrap();
      });
    });

    if (history.pushState) {
      history.pushState({}, null, url);
    }
  }

  // Return API for other modules
  return {};
})(jQuery);
