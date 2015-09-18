var Main = (function($){
  $(function(){
    $(document).on('ready', function(){
      contentReady(document.body);
    });
  });

  function contentReady(element) {
    $(document).trigger('content-ready', element);
  }

  // Return API for other modules
  return {
    contentReady: contentReady
  };
})(jQuery);
