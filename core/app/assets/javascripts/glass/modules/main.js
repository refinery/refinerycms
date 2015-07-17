var Main = (function($){
  $(function(){
    $(document).on('ready', function(){
      contentReady(document.body);
    });
  });

  function contentReady(element) {

    $(document).trigger('content-ready', element);
    $('.btn-anchor').removeAttr('disabled');
    btnAnchorInitialization(element);
    initializePreviewButtonListener(element);
    // Check for desktop firefox
    var isFirefox = typeof InstallTrigger !== 'undefined';
    // check for mobile firefox.
    if(!isFirefox){
      isFirefox = navigator.platform.toLowerCase().indexOf("firefox") > -1;
    }

    if(isFirefox){
      $('body').addClass('mozilla');
    }
  }

  /**
   * If a preview button is pressed, fire an event to
   * trigger the allowance of leaving the current page.
   * @param element - the container element to initialize on.
   */
  function initializePreviewButtonListener(element){
    $(element).find('.preview-button').click(function(){
      $(document).trigger('allow-page-unload', {
        src: 'Preview Link/Button',
        selector:'.preview-button',
        value: false
      });
    });
  }

  /**
   * Set items with btn-anchor class so that they behave like
   * <a> tags.
   * @param element - the container element to initialize on.
   */
  function btnAnchorInitialization(element){
    $(element).find('.btn-anchor').unbind('click').click(function (e) {
      e.preventDefault();
      var $btn = $(this);

      // if the btn has the class btn-anchor-outbound its url should be opened in a new window.
      if($btn.hasClass('btn-anchor-outbound')){
        window.open($btn.attr('data-url'));
      } else {
        window.location.href = $btn.attr('data-url');
      }
    });

    var $selectInput = $(element).find('.select-anchors');

    $selectInput.change(function(e){
      e.preventDefault();
      if($selectInput.hasClass('anchors-outbound')){
        window.open($selectInput.val());
      } else {
        window.location.href = $selectInput.val();
      }
    });
  }

  // Return API for other modules
  return {
    contentReady: contentReady
  };
})(jQuery);
