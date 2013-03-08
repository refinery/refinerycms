$(function() {
  $('.tree').on('click', '.toggle', function(e) {
    e.preventDefault();
    var $li   = $(this).parents('li:first');
    var $icon = $li.find('.icon.toggle');
    var $nested = $li.find('.nested');

    if ($icon.hasClass('expanded')) {
      $icon.removeClass('expanded');
      $nested.slideUp(); 
    }
    else {
      var contentUrl = $nested.data('ajax-content');
      $li.addClass('loading');
      
      $nested.load(contentUrl, function() {
        $nested.find('li:last').addClass('branch_end');
        $icon.addClass('expanded');
        init_tooltips();
        $nested.slideDown(); 
        $li.removeClass('loading');
      });
    }
  });
});
