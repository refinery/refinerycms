/**
 * Created by jkrump on 23/03/15.
 */

var GlassPagination = (function ($) {
  var FETCHING = false;

  $(document).on('content-ready', function (e, element) {
    var $paginationSpinnner = null;

    if(!FETCHING){
      $paginationSpinner = setListeners();
    }

    $(document).unbind('pagination-content-loaded').on('pagination-content-loaded', function(e, element) {
      FETCHING = false;
      $paginationSpinnner = setListeners();
      $paginationSpinner.fadeOut(200);
    });

  });

  function setListeners(){
    var $showMoreButton = $('.btn-paginate-show-more');
    var $infiniteScrollContainer = $('.infinite-scrolling-container');
    var $paginationSpinner = $('.pagination-spinner');

    if($showMoreButton.length > 0 && (parseInt($showMoreButton.data('total-pages')) > 1)){
      $showMoreButton.attr('data-total-pages', 1);

      $showMoreButton.unbind('click').click(function(e){
        e.preventDefault();
        if(!FETCHING){
          FETCHING = true;
          $(window).unbind('scroll', scrollHandler);

          var moreUrl = $(this).attr('data-url');
          if(moreUrl){
            getMoreContent(moreUrl, $paginationSpinner);
          } else {
            console.warn('No URL specified');
          }
        }
      });
    }

    if ($infiniteScrollContainer.length > 0 && (parseInt($infiniteScrollContainer.data('total-pages')) > 1)){
      $infiniteScrollContainer.attr('data-total-pages', 1);

      $(window).unbind('scroll', scrollHandler).on('scroll', scrollHandler);
    } else {
      $(window).unbind('scroll', scrollHandler);
    }
    return $paginationSpinner;
  }

  function scrollHandler(){
    
    var moreUrl = $('.infinite-scrolling-container').attr('data-url');
    var pixelOffsetFromBottom = 1200;
    var $paginationSpinner = $('.pagination-spinner');

    if(moreUrl && ($(window).scrollTop() > ($(document).height() - $(window).height() - pixelOffsetFromBottom))){
      if(!FETCHING){
        getMoreContent(moreUrl, $paginationSpinner);
      }
    }
  }

  function getMoreContent(moreUrl, $paginationSpinner){
    var $adminSearchInput = $('#search');

    FETCHING = true;
    $(window).unbind('scroll', scrollHandler);

    // Append search param if there was one.
    if($adminSearchInput.length === 1){
      var paramName = moreUrl.indexOf('?') !== -1 ? '&search=' : '?search='
      moreUrl += (paramName + $adminSearchInput.val());
    }
    displaySpinner($paginationSpinner);
    $.getScript(moreUrl);
  }

  /**
   *
   * @param $paginationSpinner
   */
  function displaySpinner($paginationSpinner){
    if($paginationSpinner.length > 0){
      $paginationSpinner.fadeIn(200);
    }
  }

  return {
    scrollHandler: scrollHandler
  }

})(jQuery);