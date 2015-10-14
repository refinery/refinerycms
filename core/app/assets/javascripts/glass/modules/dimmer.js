/**
 * Created by StefanS on 2015-Aug-20
 */

var GlassDimmer = (function ($) {
  $(document).on('content-ready', function (e, element) {
    $(element).find('.toggle-dimmed-editing').click(function (e) {
      var $btn = $(this);
      var $dimmer = getDimmer();

      if ($btn.hasClass('active')) {
        $btn.removeClass('active');
        $dimmer.removeClass('dimmed-editing');
      }
      else {
        $btn.addClass('active');
        $dimmer.addClass('dimmed-editing');
      }
    });
  });

  function getAllDimmers(container) {
    return $(container).find(".dimmer");
  }

  function getDimmer() {
    return getAllDimmers('body').first();
  }

  function dim() {
    var $dimmer = getDimmer();
    $dimmer.addClass('dimmed');
  }

  function unDim() {
    getAllDimmers('body').removeClass("dimmed");
  }

  // Return API for other modules
  return {
    dim:           dim,
    unDim:         unDim,
    getDimmer:     getDimmer,
    getAllDimmers: getAllDimmers
  };
})(jQuery);
