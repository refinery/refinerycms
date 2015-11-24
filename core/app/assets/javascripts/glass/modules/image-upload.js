var GlassImageUploader = (function ($) {
  $(document).on('content-ready', function (e, element) {
    var $upload_btns = $(element).find('.image-upload-btn');
    if ($upload_btns.length > 0) {

      // TODO: Deprecate this loop when all image btns have a data-image-input-id attr on them (input_id variable)
      $upload_btns.each(function () {
        var $upload_btn = $(this);
        var $container = $(this).parents('.upload-preview-container');
        if (!$upload_btn.data('image-input-id') && $container.length > 0) {
          var $img_field = $container.parents('form')
            .find('.image-upload-container[data-field-name="' + $container.data('field-name') + '"] .image-id-field');
          var $preview_div = $container.find('.file-preview');

          if ($img_field.length > 0) {
            $upload_btn.attr('data-image-input-id', $img_field.attr('id'));

            if ($preview_div.length > 0) {
              $preview_div.attr('data-image-bg-id', $img_field.attr('id'));
            }
          }
        }
      });

      $upload_btns.each(function () {
        var $upload_btn   = $(this);
        var $img_field    = $('#' + $upload_btn.data('image-input-id'));
        var $container    = $(this).parents('.upload-preview-container');
        var $progress_bar = ($container.length > 0 ? $container : $upload_btn               ).find('.progress');
        var $error_div    = ($container.length > 0 ? $container : $img_field.parents('form')).find(".errorExplanation").first();

        $upload_btn.click(function (e) {
          e.preventDefault();
          GlassUploader.openFileInput('#img-upload-form', $upload_btn);
          if ($progress_bar.length > 0) {
            $progress_bar.val(0);
          }
        });

        GlassUploader.handleProgressUpdates($upload_btn, $progress_bar);

        $upload_btn.data('on-success', function(response) {
          $upload_btns.filter('[data-image-input-id="' + $upload_btn.data('image-input-id') + '"]').each(function () {
            if ($(this).text().replace(/\W+/g, ' ').length > 3) {
              $(this).text('Replace Image');
            }
          });
          var $preview_divs = $('[data-image-bg-id="' + $upload_btn.data('image-input-id') + '"]')
          $preview_divs.show();
          $preview_divs.css('background-image', 'url(' + response.url + ')');

          if ($progress_bar.length > 0) {
            $progress_bar.addClass('hidden-xs-up');
          }

          $img_field.val(response.image_id);
          CanvasForms.triggerAutoSave($img_field.parents('form'), $img_field);

          $error_div.removeClass('active');
          $error_div.html('');
        });

        $upload_btn.data('on-error', function(response_text) {
          $error_div.html("<p>" + response_text + "</p>")
          $error_div.addClass('active');
        });
      });
    }

    var $delete_btns = $(element).find('.image-delete-btn');
    $delete_btns.click(function () {
      var $container  = $(this).parents('.upload-preview-container');
      var $upload_btn = $container.find('[data-image-input-id]').first();
      var $img_field  = $('#' + $upload_btn.data('image-input-id'));
      $img_field.val('');

      var $preview_divs = $('[data-image-bg-id="' + $upload_btn.data('image-input-id') + '"]')
      $preview_divs.css('background-image', '');
    });
  });

  // Return API for other modules
  return {
  };
})(jQuery);
