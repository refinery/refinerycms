/**
 * Created by StefanS on 2015-Aug-20
 */

var GlassButtons = (function ($) {
  $(document).on('content-ready', function (e, element) {
    $(element).find('[data-toggle-active]').each(function (){
      $(this).click(function (e) {
        var $elem = $($(this).data('toggle-active'));
        $elem.hasClass('active') ? $elem.removeClass('active') : $elem.addClass('active');
      });
    });
  });

  // Return API for other modules
  return {
  };
})(jQuery);
