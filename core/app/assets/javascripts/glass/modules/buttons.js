/**
 * Created by StefanS on 2015-Aug-20
 */

var GlassButtons = (function ($) {
  $(document).on('content-ready', function (e, element) {
    $(element).find('[data-toggle-active]').each(function (){
      $(this).click(function (e) {
        var $elem = $($(this).data('toggle-active'));
        $elem.hasClass('active') ? $elem.removeClass('active') : $elem.addClass('active');
      });
    });

    btnAnchorInitialization(element);
  });

  // I think we should get rid of this, just use <a>'s [SS]
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
  };
})(jQuery);
