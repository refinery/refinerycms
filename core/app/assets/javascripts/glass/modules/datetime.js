/**
 * Created by jkrump on 16/03/15.
 */

var GlassDateTime = (function ($) {
  $(document).on('content-ready', function (e, element) {
    var icons = {
      time: 'icon icon-clock',
      date: 'icon icon-calendar',
      up: 'icon icon-up',
      down: 'icon icon-down',
      previous: 'icon icon-angle-left',
      next: 'icon icon-angle-right',
      today: 'icon icon-crosshair',
      clear: 'icon icon-trash',
      close: 'icon icon-close'
    };

    $('.datetimepicker.default').datetimepicker({
      useCurrent: true,
      defaultDate: new Date(),
      icons: icons
    });
    $('.datetimepicker.side-by-side').datetimepicker({
      sideBySide: true,
      useCurrent: true,
      defaultDate: new Date(),
      icons: icons
    });
    $('.datetimepicker.time-only').datetimepicker({
      useCurrent: true,
      format: 'LT',
      defaultDate: new Date(),
      icons: icons
    });
    $('.datetimepicker.date-only').datetimepicker({
      useCurrent: true,
      format: 'MM/DD/YYYY',
      defaultDate: new Date(),
      icons: icons
    });
  });

  return {}

})(jQuery);