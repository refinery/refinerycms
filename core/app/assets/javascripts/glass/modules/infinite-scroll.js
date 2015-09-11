/**
 * Created by jkrump on 2015-Mar-23
 * Refactored by Stefan Spicer on 2015-Jun-19
 */

var GlassInfiniteScroll = (function ($) {
  var next_page = 2;
  var fetch_in_progress = false;
  var container_selector = '.infinite-scroll-container';

  $(document).on('content-ready', function (e, element) {

    var $container = $(element).find(container_selector);

    if ($container.length > 0) {
      $(window).on('scroll', loadMoreItems);
    }
  });

  var loadMoreItems = function () {
    var $container = $(container_selector);
    var total_pages = $container.data('pages-total');
    var $spinner = $('.pagination-spinner');
    var spinner_is_almost_on_the_screen = $(window).scrollTop() + $(window).height() + 1200 > $spinner.offset().top;

    if (next_page <= total_pages && !fetch_in_progress && spinner_is_almost_on_the_screen) {
      fetch_in_progress = true;
      $spinner.children().show();

      var url = buildURL(next_page);

      $.get(url, function(data) {
        $spinner.children().hide(); // don't hide the container so we can still get the offset()

        var $new_items = $(data).find(container_selector);
        $new_items = $new_items.length > 0 ? $new_items.contents() : $new_items = $(data);
        var $new_container = $('<div></div>').append($new_items);

        $container.append($new_container);
        $(document).trigger('content-ready', $new_container); // only on the new items
        $new_container.children().unwrap();
        fetch_in_progress = false;
        loadMoreItems(); // In case user is waiting without scrolling, fetch again
      });
      next_page++;
    }
  }

  /**
   * Helper method for building the URL to use in a page request.
   */
  var buildURL = function (next_page){
    var url = window.location.href;
    var hasGetParam = url.indexOf('?') !== -1;
    var $adminSearchInput = $('#search');
    var searchVal = $adminSearchInput.length === 1 ? $adminSearchInput.val().trim() : null;
    // Append search param if there was one.
    if(searchVal !== null && searchVal.length > 0){
      var paramName = url.indexOf('?') !== -1 ? '&search=' : '?search='
      url += (paramName + searchVal);
      hasGetParam = true;
    }

    url += (hasGetParam ? '&' : '?') + 'page=' + next_page;

    return url;
  };

  return {
    loadMoreItems: loadMoreItems
  }
})(jQuery);
