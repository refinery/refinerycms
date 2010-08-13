if (typeof($) == 'function') {
  $(document).ready(function() {
    $logo = $('#site_bar_content #site_bar_refinery_cms_logo');
    $logo.css('left', ($('#site_bar_content').width() / 2) - ($logo.width() / 2));

    if ($.isFunction($('#editor_switch a').corner)) {
      $('#editor_switch a').corner('6px');
    }

    $('#editor_switch a').appendTo((span = $('<span></span>').prependTo('#editor_switch')));
    if ($.isFunction(span.corner)) {
      span.corner('6px');
    }
  });
}