var CanvasForms = (function ($) {
  setVerify();

  String.prototype.capitalizeFirstLetter = function() {
      return this.charAt(0).toUpperCase() + this.slice(1);
  }

  $(document).on('content-ready', function (e, element) {
    // initialize verify (form validation library)
    initVerify(element);

    initFormSelectsWithin(element);
    initFormOptionalFieldsWithin(element);
    initFormSubmitWithin(element);
    initAutoSave(element);
    initConfirmDelete(element);
  });

  function hideAlert() {
    var $alert = $('.auto-save-state');
    var showing_ms = (new Date()).getUTCSeconds() - $alert.data('sent-at');
    var goal_ms    = 1500;

    if (showing_ms < goal_ms) {
      setTimeout(function() {
        $alert.removeClass("active");
      }, goal_ms);
    }
    else {
      $alert.removeClass("active");
    }
  }

  function displayAlert(message) {
    var $alert = $('.auto-save-state');

    if (message == 'sending') {
      $alert.removeClass("finished");
      $alert.data('sent-at', (new Date()).getUTCSeconds());
    }
    else {
      $alert_message = $alert.find(".finished-state .msg");
      $alert_message.text((message.constructor === Array) ? message.join("") : message);
      $alert.addClass("finished");
    }

    $alert.addClass("active");
  }

  function autoSave($form, changed_element) {
    var online = navigator.onLine;
    if (!$form.hasClass('auto-save')) {
      return;
    }

    if ($form.find(".autosave-field").length == 0) {
      $form.append($("#autosave_field").clone());
    }
    $form.find(".autosave-field").val(true);
    // TODO: change form-before-submit event to a non-queued event so this works:
    // $form.submit();
    $form.data("submit-btns").not('.publish-button').first().click();
  }

  function triggerAutoSave($form, changed_element) {
    if (!$form.hasClass('auto-save')) {
      return;
    }

    autoSave($form, changed_element);
    $form.data("watcher").manually_triggered();
  }

  function autoSaveComplete(http_status, message, $response) {
    if (http_status == 200) {
      hideAlert();
      return;
    }

    if (http_status == 409) {
      $('#conflict_modal').remove();
      $('body').append($response);
      var $conflict_modal = $('#conflict_modal');
      if ($conflict_modal.length > 0) {
        $conflict_modal.modal('show');
      }

      if (message == undefined) {
        message = "Error: Someone is already editing";
      }
    }

    displayAlert(message != undefined ? message : "Save failed. Please check your internet connection.");
  }

  function initAutoSave(element) {
    var $auto_save_form = $(document).find('form.auto-save');

    if ($auto_save_form.length > 0) {
      watcher = new WatchForChanges.Watcher({
        'onchange'   : $auto_save_form.find('input, textarea'),
        'onkeypress' : $('.glass-edit'),
        'callback'   : function (element) { autoSave($auto_save_form, element); },
      });
      $auto_save_form.data("watcher", watcher);
      $auto_save_form.data("allow-unload", true);
    }
  }

  function initFormSelectsWithin(element) {
    if ($(element).find('select').length > 0) {
      if ('MozAppearance' in $(element).find('select')[0].style) {
        $('html').addClass('moz-appearance');
      }
    }
  }

  var COUNT = 0;

  // Set custom validation rules and initialize verify.
  function initVerify(element){

    var $element = $(element);
    // Add the disabled attribute to buttons in the form
    var $formButtons = $element.find('form button');
    $formButtons.attr('disabled', 'disabled');
    // Set data values for evaluating unique fields
    var url;

    $element.find('[data-unique-collection-url]').each(function(){
      var $field = $(this);
      url = $field.data('unique-collection-url');
      $.get(url, function(response) {
        var collection = response.collection;
        if(collection !== undefined){
          $field.data('unique-collection', collection);
        }
      });
    });

    // if this rule has not yet been added, then add it now.
    if($.verify._hidden.ruleManager.getRawRule('required_w_name') === undefined){
      $.verify.addRules(customValidationRules());
    }
    initVerifyForm($element);
    // remove the disabled attribute from all buttons within
    // forms once the js has loaded.
    $formButtons.removeAttr('disabled');
  }

  var customValidationRules = function(){
    return {
      required_w_name: function(r) {
        var $label = $(r.field).parents('.form-group').find('label');
        var fieldName = $(r.field).data('val-field');
        var message;
        var inputValue = r.val();
        var fieldNamePrefix = $(r.field).data('val-prefix');
        var messagePrefix = fieldNamePrefix === undefined ? 'The ' : fieldNamePrefix + ' ';

        if((inputValue.trim() === '') || (inputValue === undefined) || (inputValue === null))
        {
          if (fieldName !== undefined){
            message = messagePrefix + fieldName + ' is required';
          } else {
            message = ($label.length > 0) ? messagePrefix + $label.text() + ' is required' : 'This field is required';
          }
          return message;
        }
        return true;
      },
      unique_value: function(r) {
        var $label = $(r.field).parents('.form-group').find('label');
        var fieldName = $(r.field).data('val-field');
        var message;
        var inputValue = r.val().toLowerCase();
        var returnVal = true;

        var collection = $(r.field).data('unique-collection');

        if(collection.length > 0){
          if(collection.indexOf(inputValue) !== -1)
          {
            if (fieldName !== undefined){
              message = 'That ' + fieldName + ' is already in use';
            } else {
              message = ($label.length > 0) ? 'That ' + $label.text() + ' is already in use' : 'That value is already taken';
            }
            returnVal =  message;
          }
        }
        return returnVal;
      }
    };
  };

  function initVerifyForm($element){

    $element.find('form').filter(function() {
      return $(this).find("[" + $.verify.globals.validateAttribute + "]").length > 0;
    }).verify();
  }

  function setVerify(){
    $.verify({
      autoInit: false,
      skipHiddenFields : false,
      errorContainer: function(input) {
        return $(input).parents('.form-group');
      },
      beforeSubmit: function(submitEvent, result) {
        var $form = $(submitEvent.target);
        var $errorInputs = $form.find('.validation.active');

        if($errorInputs.length > 0){
          scrollToVerifyErrors($form, $errorInputs);
          return false;
        }
        $form.trigger('validation-success');
        return true;
      },
      hideErrorOnChange: true,
      prompt: function(element, text, opts) {
        var $errorContainer, $validationContainer = $(element).parents('.form-group').find('.validation');

        if($validationContainer.length > 0 && ($errorContainer = $validationContainer.find('span')).length > 0){

          if($errorContainer.length > 1){
            $validationContainer = $errorContainer = $(element).parent().find('.validation').first();
            $errorContainer = $validationContainer.find('span');
          }

          if(text){
            $validationContainer.addClass('active');
          } else {
            $validationContainer.removeClass('active');
          }
          $errorContainer.html(text || '');
        }
      }
    });
  }

  function scrollToVerifyErrors($form, $errorInputs)
  {
    var COUNT = 0;
    if($errorInputs.length > 0){
      var $firstError = $errorInputs.first();

      // after a short delay, scroll to the input with the error.
      if (COUNT < 1) {
        COUNT++;

        setTimeout(function () {
          if ($firstError.parents("#sidebar-right-inner").length > 0) {
            $("#sidebar-right-inner").animate({
              scrollTop: 0
            }, 500);
          }
          else {
            $('html, body').animate({
              scrollTop: parseInt($firstError.offset().top) - 73
            }, 500);
          }
          COUNT = 0;
        }, 100);
      }
    }
  }

  function initFormOptionalFieldsWithin(element) {
    // TODO: make this generic so any form can use it - I think rccav funeral form has a good function
    $(element).find("#registration_situation").change(function () {
      $("#registration_situation_other").parents('.form-group')
        .toggle($(this).val() === "Other");
      $("#registration_situation_contraception").parents('.form-group')
        .toggle($(this).val().match(/contracept/i) !== null);
    });
    $(element).find("#registration_how_find").change(function () {
      $("#registration_how_find_other").parents('.form-group')
        .toggle($(this).val() === "Other");
    });
    $(element).find("#registration_situation").change();
    $(element).find("#registration_how_find").change();
  }

  function initAjaxForm($form) {
    var $submit_btns = $form.find('.btn[type="submit"], .sudo-submit');
    $submit_btns.each(function () {
      $(this).data('orig-btn-txt', $(this).html());
    });

    $form.keypress(function (e) {
      if (e.keyCode == 13) {
        e.preventDefault();
      }
    });

    $form.data("submit-btns", $submit_btns);
    $form.data("submit-btn",  $submit_btns.not('.publish-button').first());
  }

  function initStopPageUnload(element, $form) {
    if ($(element).find('#page-preview').length > 0) {
      window.onbeforeunload = function() {
        var stop_message = 'You are currently editing site content. Any changes you\'ve made will be lost if you leave this page now. Use the "Publish settings" menu to save first.';

        return $form.data("monitor-page-unload") && !$form.data("allow-unload") ? stop_message : undefined ;
      };
    }
  }

  function initFormSubmitWithin(element) {
    $(element).find('form').each(function () {
      if ($(this).hasClass('no-ajax')) {
         return;
      }

      if (!($(this).hasClass('ajax-form') || $(this).parents('.modal').length > 0)) {
        return;
      }
      var selector = "#" + $(this).attr('id');
      var $form = $(this);

      initAjaxForm($form);
      initStopPageUnload(element, $form);
      var $submit_btns = $form.data("submit-btns");

      $submit_btns.click(function (e) {
        var $submit_btn = $(this);
        $form.data("submit-btn", $submit_btn);

        var $draft_field = $form.find('.draft-field');
        if ($draft_field.length > 0) {
          $draft_field.val($submit_btn.hasClass('mark-as-draft'));
        }

        var $publish_field = $form.find('.publish-field');
        if ($publish_field.length > 0) {
          $publish_field.val($submit_btn.hasClass('publish-button'));
        }

        //Might be tempting to put this in beforeSubmit... but DON'T (timing issue)
        $form.trigger('form-before-submit');
        return true;
      });

      $('.allow-unload').click(function (e) {
        $form.data("allow-unload", true);
      });

      $form.ajaxForm({
        dataType: 'json',
        beforeSubmit: function(arr, $form, options){
          if ($form.data("submitted")) {
            return false;
          }

          $form.data("submitted", "clicked");
          var $autosave_field = $form.find(".autosave-field");
          if ($autosave_field.length > 0 && $autosave_field.val() == 'true') {
            $form.data("submitted", "autosaved");
            displayAlert('sending');
          }

          disableSubmit($form);
        },

        success: function(e, response, statusText, xhr, element) {
          $form.trigger('form-submit-success', [e, response, statusText, xhr, element]);
        },

        complete: function (xhr, status) {
          if ($form.hasClass('mailchimp')) {
            replaceContent($form, $("<p>Thank you!</p>"));
            return;
          }

          var replace_selector = $form.data('ajax-replace-selector');
          var callback = $form.data('on-complete-callback');
          var $replace_form; // if the same form that was submitted is in response, replace it
          var $callback_param;
          var autosaved = ($form.data("submitted") === 'autosaved');

          $form.data('redirect-on-success', true);

          if (xhr.responseJSON) {
            $callback_param = xhr.responseJSON;
          }
          else {
            $replace_form = replace_selector ? $(xhr.responseText).find(replace_selector) : $(xhr.responseText).find(selector);
            $callback_param = $replace_form.length > 0 ? $replace_form : $(xhr.responseText);
          }

          // If there is a callback call it.
          if (callback !== undefined && callback !== null) {
            var result = callback($callback_param);
            if (result === false) {
              return;
            }
            if (result === 'no-redirect') {
              $form.data('redirect-on-success', false);
            }
          }

          var $error_response = null;
          var $replacement = $('<p>Thank you</p>'); // Default response message
          var status_message = undefined;

          // Determine error or success and set variables appropriately
          if (xhr.responseJSON) {
            status_message = xhr.responseJSON.message;

            if (xhr.status == 200) {
              if (!status_message) {
                status_message = "Everything is 'A' OK!";
              }

              $replacement = $("<p>" + status_message + "</p>");
            }
            else {
              $error_response = xhr.responseJSON.errors != undefined ? xhr.responseJSON.errors : (status_message ? status_message : 'Unknown Error');
            }
          }
          else if (xhr.responseText) {
            var $page_body      = $(xhr.responseText).find('#body_content, .glass-edit-html'); // if response is a page, use inner content
            var $error_response = ($(xhr.responseText).attr('id') === 'errorExplanation') ? $(xhr.responseText) : $replace_form.find('#errorExplanation');

            if (!($error_response.length > 0 && $error_response.hasClass('active'))) {
              $error_response = null;
            }

            if ($replace_form.length > 0) {
              $replacement = $replace_form;
            }
            else if ($page_body.length > 0) {
              $replacement = $page_body.first();
            }

            if (xhr.status != 200 && !$error_response) {
              $error_response = $replacement;
            }
            // its considered success if xhr.status == 200 AND !$error_response
          }
          else if (status == 'error') {
            $error_response = 'Error saving.  Please check your network connection';
          }

          // Handle error or success
          if (autosaved) {
            autoSaveComplete((xhr.status == 200 && $error_response) ? 400 : xhr.status, status_message, $error_response ? $error_response : $replacement);
            $form.data('allow-unload', xhr.status == 200 || xhr.status == 409 || $error_response == null);
          }
          else if ($error_response != null) {
            insertErrors($form, $error_response, null);
            $form.data("allow-unload", false);
          }
          else {
            handleSuccess($form, $replacement);
            $form.data("allow-unload", true);
          }

          resetSubmit($form);
        }
      });
    });
  }

  function resetSubmit($form) {
    var submit_btn = $form.data("submit-btn");
    var submit_btns = $form.data("submit-btns");
    submit_btn !== undefined ? submit_btn.html($form.data("submit-btn").data('orig-btn-txt')) : '';
    submit_btns !== undefined ? submit_btns.removeAttr('disabled') : '';

    var $autosave_field = $form.find(".autosave-field");
    if ($autosave_field.length > 0) {
      $autosave_field.val(0);
    }

    $form.removeData("submitted");
  }

  function disableSubmit($form) {
    $form.data("submit-btn").html('<i class="active inline xs loader"></i> Sending');
    $form.data("submit-btns").attr('disabled', 'disabled');
  }

  function handleSuccess($form, $replacement) {
    var $submit_btn      = $form.data("submit-btn");
    var $modal           = $form.parents('.modal');
    $form.find('.errorExplanation').addClass('hidden-xs-up');

    if ($modal.length > 0) {
      var $elem = $modal.find('.update-on-close');

      if ($elem.length > 0) {
        ajaxUpdateContent($elem.data('selector'));
      }
      $modal.modal('hide');
    }
    else if ($form.data('redirect-on-success')) {
      var redirect_url = $submit_btn.data('redirect-url');

      if (redirect_url !== undefined && redirect_url !== null) {
        window.location.href = redirect_url;
      } else if($replacement !== null) {
        // inquiries engine puts an h1 in there
        $replacement.find('h1').remove();
        $('html, body').animate({
          scrollTop: $form.offset().top - 200
        }, 500);
        replaceContent($form, $replacement);
      }
    }
  }

  function initConfirmDelete(element) {
    $(element).find('a#delete_button, .delete-modal').click(function(e){
      e.preventDefault();
      var $btn = $(this);

      //Loaded from _confirm_delete_modal.html.erb through admin.html.erb
      var $deletionModal = $('#delete-confirm-modal');
      if ($deletionModal.length > 0) {
        $deletionModal.find('#myModalLabel').text($btn.attr('data-text'));
        var $confirmBtn = $deletionModal.find('#modal-delete-button');
        $confirmBtn.attr('data-url',                $btn.attr('data-url'));
        $confirmBtn.attr('data-redirect-url',       $btn.attr('data-redirect-url'));
        $confirmBtn.attr('data-no-redirect',        $btn.attr('data-no-redirect'));
        $confirmBtn.attr('data-container-selector', $btn.attr('data-container-selector'));
        $confirmBtn.html($btn.html());
        $deletionModal.modal('show');
      }
      else {
        console.warn("WARNING: #delete-confirm-modal is undefined");
      }
    });

    $(element).find('#delete-confirm-modal .confirm-modal-delete').click(function(e){
      e.preventDefault();
      var $confirmBtn = $(this);
      $.ajax({
        url: $confirmBtn.attr('data-url'),
        type: 'DELETE',
        success: function(result) {
        }
      }).always(function(){
        if($confirmBtn.attr('data-no-redirect')){
          var containerSelector = $confirmBtn.attr('data-container-selector');

          if(containerSelector){
            var $containerElement =  $($confirmBtn.attr('data-container-selector'));
            $containerElement.fadeOut(300, function(){
              $(this).remove();
            });
          }
        } else {
          window.location.href = $confirmBtn.attr('data-redirect-url');
        }
      });
    });
  }

  function ajaxUpdateContent(update_selector) {
    if (update_selector) {
      $.get(document.URL, function(data) {
        var $replacement = $(data).find(update_selector)
        $(update_selector).replaceWith($replacement);
        $(document).trigger('content-ready', $(update_selector));
      });
    }
  }

  function replaceContent($orig, $replacement) {
    $(document).trigger('content-ready', $replacement.parent()[0]);
    $orig.fadeOut(function () {
      $(this).replaceWith($replacement);
      $replacement.fadeIn();
    });
  }

  function resetState() {
    $('.help-inline').remove();
    $('.error').removeClass('error');
  }

  function insertErrors(form, errorMessages, imageForm) {
    if (imageForm !== null && imageForm !== undefined) {
      insertMessage('image', errorMessages);
      return 0;
    }

    var errorContainer = prepareErrorContainer(errorMessages);

    var $error_explanation = form.find('#errorExplanation');
    $error_explanation.empty().append(errorContainer);
    $error_explanation.addClass('active');

    resetSubmit(form);
    scrollToVerifyErrors(form, $error_explanation);
  }

  function insertMessage(attribute, errorMessages) {
    var errorMessage = ['<span class="help-inline text-danger">', errorMessages[attribute][0], '</span>'].join("");

    if (attribute === 'image') {
      $('.file-preview').addClass('error').after(errorMessage);
    } else {
      var inputSelector = $('input[name="' + attribute + '"]');
      inputSelector.parents('.form-group').addClass('error');

      if (inputSelector.parents('.input-group').length > 0) {
        inputSelector.parents('.input-group').after(errorMessage);
      } else {
        inputSelector.after(errorMessage);
      }
    }
  }

  function prepareErrorContainer($error) {
    var errorContainer = [];

    if($error instanceof jQuery) {
      return $error;
    }
    else {
      errorContainer.push("<div>");
      errorContainer.push("<p>There were problems with the following:</p>");
      errorContainer.push("<ul class='payment-errors list-unstyled'>");

      if(Array.isArray($error)) {
        $($error).each(function (index, message) {
          errorContainer.push("<li>" + message + "</li>");
        });
      }
      else {
        errorContainer.push("<li>" + $error + "</li>");
      }
      errorContainer.push("</ul></div>");
    }
    return errorContainer.join("");
  }

  function liveValidateRequiredFields(fields){
    var waitTimeMS = 500;
    var field;
    // TODO: Once usages of this method have been removed. Delete this method.
  }

  // Return API for other modules
  return {
    replaceContent: replaceContent,
    ajaxUpdateContent: ajaxUpdateContent,
    insertErrors: insertErrors,
    resetState: resetState,
    liveValidateRequiredFields: liveValidateRequiredFields,
    initFormSubmitWithin: initFormSubmitWithin,
    initVerify: initVerify,
    initAjaxForm: initAjaxForm,
    disableSubmit: disableSubmit,
    resetSubmit: resetSubmit,
    scrollToVerifyErrors: scrollToVerifyErrors,
    triggerAutoSave: triggerAutoSave
  };
})(jQuery);
