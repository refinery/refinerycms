/**
 * Created by jkrump on 02/12/14.
 */

 var ModalCreate = (function($){
  $(document).on('content-ready', function (e, element) {
    $(element).find('a.open-modal-form').click(function (e) {
      e.preventDefault();
      var btn = $(this);
      var modelName = btn.data('model-name');
      var updateOnClose = btn.data('update-on-close');
      var nestedFormBtn = btn.data('callback-modal');
      var modal_title   = btn[0].textContent || btn[0].innerText;
      if (modelName) {
        modal_title     = 'Create a new ' + modelName;
      }

      var $modal = $('#sub-form-modal');

      var $modal_body = $modal.find('.modal-body');

      $modal_body.load(btn.attr('href') + ' #page', function () {
        $(document).trigger('content-ready', $modal_body[0]);
        var $nested_form_btn = $modal_body.find('a.open-modal-form');
        if($nested_form_btn.length > 0){
          $nested_form_btn.removeClass('open-modal-form');
          $nested_form_btn.unbind('click');
            // $nested_form_btn.attr('data-callback-modal', btn.attr('id'));
        }

        // Append a useless element that has a data attribute who's value is 
        // needed. Unfortunately, can't manipulate data values on the modal 
        // because it's data values are used when it is initialized on the page 
        // and they cannot be modified after this it appears.
        // 
        // TODO: find a better way to do this. 
        // 
        $modal_body.prepend('<div class="update-on-close" class="hidden" ' +
          'data-selector="' + updateOnClose + '"></div>');
        
        if(nestedFormBtn){
          // For reasoning behind why this element is added, see previous 
          // comment above.
          $modal_body.prepend('<div id="callback-modal" class="hidden" ' + 
            'data-selector="#' + nestedFormBtn + '"></div>');
        }
        $modal.find('.modal-title').text(modal_title);
      });

      $modal.modal('show');
    });
  });

  return {};
})(jQuery);
