function scrollTo(target_selector, top_offset) {
  var $target = typeof target_selector == 'string' ? $(target_selector) : target_selector;
  top_offset  = typeof top_offset  !== 'undefined' ? top_offset : 100;
  if ($target.length > 0) {
    var destval = $target.offset().top - top_offset;
    var speed = Math.floor(Math.abs(destval - $(window).scrollTop()) / 200) * 100; // rounded down 100
    if (speed < 800) {
      speed = Math.floor(400 + (speed / 2));
    }
    if (speed < 2000) {
      $('html, body').animate({
        scrollTop: destval
      }, speed, function () {
        $('#header').addClass('inattic');
      });
    }
    else {
      var $form = $target.parent();
      $form.animate({
        opacity: 0
      }, 500, function() {
        $('html, body').animate({ scrollTop: destval }, 0);
        $form.animate({ opacity: 1 });
      });
    }
  }
}
