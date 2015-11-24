/**
 * Created by StefanS on 2014-Dec-23
 */

var GlassSearch = (function ($){
  var watcher;

  $(document).on('content-ready', function (e, element) {
    var $search_form = $(element).find('.search-form');
    if ($search_form.length > 0) {
      if (!$search_form.is('form')) {
        // I don't know where the form .parent(), but it's how I found this code [SS]
        $search_form = $search_form.find('form').length > 0 ? $search_form.find('form') : $search_form.parent();
      }

      // Create a watcher (watch for onchange & onkeypress events)
      watcher = new WatchForChanges.Watcher({
        'onkeypress' : $search_form.find('input#search'),
        'callback'   : do_search,
        'delay'      : 400,
        'maxdelay'   : 1000
      });

      var $error_div = '<div id="errorExplanation" class="errorExplanation text-xs-center">Sorry, no results found</div>';

      $search_form.ajaxForm({
        complete: function(xhr, status) {
          var $btnContainer = $('#refinery-search-btn');

          watcher.resume();

          var $previousError = $('#errorExplanation');

          if($previousError.length > 0){
            $previousError.remove();
          }

          if (status !== 'success') {
            if(xhr.responseJSON.message !== undefined){
              // insert the error div into the page if there is a message returned from the server.
              $search_form.prepend([
                '<div id="errorExplanation" class="errorExplanation text-xs-center">',
                xhr.responseJSON.message,
                '</div>'
              ].join(''));
            }
            return;
          }
          xhr.done(function(data) {
            $btnContainer.removeClass('searching');

            var callback = $btnContainer.data('callback');
            if (callback) {
              callback(data);
            }
            else {
              var $content = $(data).find('.sortable_list');
              if ($content.length > 0) {
                $('#errorExplanation').remove();

                CanvasForms.replaceContent($('.sortable_list'), $content);
              }
              else {
                $search_form.prepend($error_div);
              }
            }
          });
        }
      });

      $search_form.find('.btn[type="submit"]').click(function(e){
        e.preventDefault();
        do_search($('#refinery-search-btn'));
      });

      $search_form.attr('autocomplete', 'off');
    }
  });

  function do_search($elem) {
    $('#refinery-search-btn').addClass('searching');
    $elem.parents('form').submit();
    watcher.pause();
  }

  // Return API for other modules
  return {
  };
})(jQuery);


