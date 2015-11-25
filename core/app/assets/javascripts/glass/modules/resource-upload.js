var GlassImageUploader = (function ($) {
  $(document).on('content-ready', function (e, element) {
    var $resource_form = $(element).find('#resource-upload-form');

    if ($resource_form.length > 0) {
      handleChooseFile($resource_form);
      handleSubmitForm($resource_form);
    }
  });

  function handleChooseFile($form) {
    $form.find('input[type="file"]').change(function (e) {
      $form.submit();
    });
  }

  function handleSubmitForm($form) {
    $form.ajaxForm({
      dataType: 'json',
      beforeSubmit: function() {},
      success: function(response, statusText, $xhr, $form) {
        var success_callback = $form.data('triggerer').data('on-success');
        if (success_callback) {
          success_callback(response);
        }
      },
      error: function(response) {
        var error_callback = $form.data('triggerer').data('on-error');
        if (error_callback) {
          error_callback(response.responseJSON.message);
        }
        console.log("FIXME: resource form error");
        console.log("FIXME: resource form error response: " + JSON.stringify(response));
      },
      uploadProgress: function(eventFired, position, total, percentComplete) {
        var progress_callback = $form.data('triggerer').data('on-progress');
        if (progress_callback) {
          progress_callback(eventFired, position, total, percentComplete);
        }
      },
      forceSync: true,
      resetForm: true
    });
  }

  // Return API for other modules
  return {
  };
})(jQuery);
