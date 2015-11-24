var GlassUploader = (function ($) {
  $(document).on('content-ready', function (e, element) {
    var $file_upload_forms = $(element).find('.glass-file-upload-form');

    $file_upload_forms.each(function () {
      handleChooseFile($(this));
      handleSubmitForm($(this));
    });
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
        console.log("ERROR: upload form error response: " + JSON.stringify(response));
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

  function openFileInput(form_selector, $trigger_btn) {
    var $form = $(form_selector);
    $form.data('triggerer', $trigger_btn);
    $form.find('input[type="file"]').click();
  }

  function handleProgressUpdates($trigger_btn, $progress_bar) {
    if ($progress_bar && $progress_bar.length > 0) {
      $trigger_btn.data('on-progress', function(eventFired, position, total, percentComplete) {
        $progress_bar.removeClass('hidden-xs-up');
        $progress_bar.val(percentComplete);
        if (percentComplete >= 100) {
          $progress_bar.addClass('progress-striped');
        }
      });
    }
  }

  // Return API for other modules
  return {
    openFileInput: openFileInput,
    handleProgressUpdates: handleProgressUpdates
  };
})(jQuery);
