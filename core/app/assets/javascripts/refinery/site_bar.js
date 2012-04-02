(function($) {
  $logo = $('#site_bar_content #site_bar_refinery_cms_logo');
  $logo.css('left', ($('#site_bar_content').width() / 2) - ($logo.width() / 2));

  $switch_anchor = $('#editor_switch a').not('.ie7 #editor_switch a, .ie6 #editor_switch a');
  if ($.isFunction($switch_anchor.corner)) {
    $switch_anchor.corner('6px');
  }

  $('#editor_switch a').appendTo((span = $('<span></span>').prependTo('#editor_switch')));
  if ($.isFunction(span.corner)) {
    span.corner('6px');
  }
})(jQuery);