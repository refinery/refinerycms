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

    $('[data-confim]').unbind();
    $(element).find('a#delete_button').unbind('click').click(function(e){
      e.preventDefault();
      openDeleteConfirmModal($(this));
    });
    $(element).find('.delete-modal').unbind('click').click(function(e){
      e.preventDefault();
      openDeleteConfirmModal($(this));
    });

    // Fire an event to allow a user to leave a page if they are on a blocked
    // page when a submit button is pressed
    $(element).find('button[type=submit]').click(function(e){
      $(document).trigger('allow-page-unload', {
        src: 'Submit Button',
        selector:'button[type=submit]',
        value: false
      });
    });
  });

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

        $(document).trigger('allow-page-unload', {
          src: 'validation fail',
          selector: 'button[type=submit]',
          value: true
        });
        setTimeout(function () {
          $('html, body').animate({
            scrollTop: parseInt($firstError.offset().top) - 73
          }, 500);
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

    $form.data("submit-btns", $submit_btns);
    $form.data("submit-btn",  $submit_btns.first());
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
      var $submit_btns = $form.data("submit-btns");

      $submit_btns.click(function (e) {
        var $submit_btn = $(this);
        $form.data("submit-btn", $submit_btn);

        var $draft_field = $form.find('.draft-field');
        if ($draft_field.length > 0) {
          $draft_field.val($submit_btn.hasClass('mark-as-draft'));
        }

        return true;
      });

      $form.ajaxForm(paramsForAjaxSubmit($form, selector));
    });
  }

  function resetSubmit($form) {
    $form.data("submit-btn").html($form.data("submit-btn").data('orig-btn-txt'));
    $form.data("submit-btns").removeAttr('disabled');
  }

  function disableSubmit($form) {
    $form.data("submit-btn").html('<i class="ui active inline inverted xs loader"></i> Sending');
    $form.data("submit-btns").attr('disabled', 'disabled');
  }

  function paramsForAjaxSubmit($form, selector) {
    return {
      beforeSubmit: function(arr, $form, options){
        disableSubmit($form);
        $form.trigger('form-before-submit');
      },

      success: function(e, response, statusText, xhr, element) {
        $form.trigger('form-submit-success', [e, response, statusText, xhr, element]);
      },

      complete: function (xhr, status) {
        if ($form.hasClass('mailchimp')) {
          $form.find('input[type="email"]').val('Thank you!');
          return;
        }

        var $previousError = $form.find('#errorExplanation');
        if($previousError.length > 0){
          $previousError.remove();
        }

        //if (status !== 'success') {
        //  - older errors come back with a 200 response, we we hadle all in 'done' for now
        //  return;
        //}

        handleXHRDone(xhr, $form, xhr.responseText, selector);
      }
    };
  }

  /**
   * Handles behavior of a page with a form on it after that form has been submitted via ajax.
   * @param $form {object} - The form that was submitted.
   * @param data           - The data that the server responded with
   * @param selector       - The unique selector for the form.
   * @param $submit_btn    - The submit button for the form
   * @param $submit_btns   - Other submit buttons for the page.
   */
  function handleXHRDone(xhr, $form, data, selector){
    var replace_selector = $form.data('ajax-replace-selector');
    // if the same form that was submitted is in response, replace it
    var $replace_form    = replace_selector ? $(data).find(replace_selector) : $(data).find(selector);
    // if response is a page, use inner content
    var $page_body       = $(data).find('#body_content, .glass-edit-html');
    var $error_response  = ($(data).attr('id') === 'errorExplanation') ? $(data) : $form.find('#errorExplanation');
    var $modal           = $(selector).parents('.modal');
    var $replacement     = null;
    var callback = $form.data('on-complete-callback');
    var redirect_on_success = true;
    var jsonResponse = xhr.responseJSON;
    var $submit_btn = $form.data("submit-btn");
    var $submit_btns = $form.data("submit-btns");

    // If there is a callback call it.
    if (callback !== undefined && callback !== null) {
      var result = callback($replace_form);
      if (result === false) {
        return;
      }
      if (result === 'no-redirect') {
        redirect_on_success = false;
      }
    }

    if(jsonResponse) {
       var message = jsonResponse.message === undefined ? 'Unknown Error' : jsonResponse.message;
       message = jsonResponse.errors === undefined ? message : jsonResponse.errors;

      $(selector).prepend(['<div id="errorExplanation" class="errorExplanation text-center red">',message,'</div>'].join(''));
      return;
    }

    if ($error_response.length > 0) {
      var $cur_error = $(selector + ' #errorExplanation');

      var $formActions = $(selector + ' .form-actions').length > 0 ? $(selector + ' .form-actions') : $(selector + ' .actions');

      if ($cur_error.length > 0) {
        replaceContent($cur_error, $error_response);
      }
      else {
        $error_response.prependTo($form);
      }
      showAndGoToErrors($form);
      resetSubmit($form);
      return; // if there was an error return early so that page doesn't get redirected.
    }

    if ($replace_form.length > 0) {
      $replacement = $replace_form;
    }
    else if ($page_body.length > 0) {
      $replacement = $page_body.first();
    } else {
      $replacement = $('<p>Thank you</p>'); // Default response message
    }

    if ($modal.length === 0 && redirect_on_success) {
      var redirect_url = $submit_btn.data('redirect-url');

      if (redirect_url !== undefined && redirect_url !== null) {
        window.location.href = redirect_url;
      } else if($replacement !== null) {
        // inquiries engine puts an h1 in there
        $replacement.find('h1').remove();
        $('html, body').animate({
          scrollTop: $(selector).offset().top - 200
        }, 500);
        replaceContent($(selector), $replacement);
      }
    } else if ($modal.length > 0) {
      var $elem = $modal.find('.update-on-close');

      if ($elem.length > 0) {
        ajaxUpdateContent($elem.data('selector'));
      }
      $submit_btn.html('Sent');
      $modal.modal('hide');
    }

    resetForm(); // resets the content of a form if necessary.

    return;
  }

  // A reset form is a form that doesn't have to be rendered again,
  // because it already exists on a page and wasn't pulled in using 'load'.
  // It simply needs its input values wiped.
  function resetForm(){
    var $resetForm = $('.ajax-reset-form');

    if ($resetForm.length > 0) {
      var $elem = $resetForm.find('.update-on-close');
      if ($elem.length > 0) {
        ajaxUpdateContent($elem.data('selector'));
        // Clear input values from the form (except for hidden values)
      }
      $resetForm.trigger("reset");
    }
  }

  function confirmDeleteListener(){
    $('.confirm-modal-delete').unbind('click').click(function(e){
      e.preventDefault();
      var $confirmBtn = $(this);
      $.ajax({
        url: $confirmBtn.attr('data-url'),
        type: 'DELETE',
        success: function(result) {

        }
      }).always(function(){
        $(document).trigger('allow-page-unload', {
          src: 'Modal model delete',
          selector: '.confirm-model-delete',
          value: false
        });

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
    if (imageForm !== null) {
      insertMessage('image', errorMessages);
      return 0;
    }

    var errorContainer = [
      '<div class="errorExplanation" id="errorExplanation">',
      '<p class="red">There were problems with the following:</p>'];

    errorContainer.push("<ul class='payment-errors list-unstyled'>");
    $(errorMessages).each(function (index, message) {
      errorContainer.push("<li class='red'>" + message + "</li>");
    });
    errorContainer.push("</ul></div>");

    var errorString = errorContainer.join("");
    form.find('#errorExplanation').replaceWith(errorString);

    showAndGoToErrors(form);
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

  function showAndGoToErrors($form) {
    var $submit_btn = $form.data("submit-btn");
    $submit_btn.html($submit_btn.data('orig-btn-txt')); // reset the text on the submit button
    $form.find('.errorExplanation').removeClass('hidden');

    $('html, body').animate({
      scrollTop: $('.errorExplanation').offset().top - 73
    }, 500);

    $form.find('button').prop('disabled', false);
  }

  function openDeleteConfirmModal($btn){

    if($('#delete-confirm-modal').length == 0){
      // Add a semantic modal to the body of the page.
      $('body').append([
        '<div id="delete-confirm-modal" class="ui basic modal">',
        '<i class="icon icon-close close"></i>',
        '<div class="header">',
        'Confirm Deletion',
        '</div>',
        '<div class="content">',
        '<div class="description">',
        '<p></p>',
        '</div>',
        '</div>',
        '<div class="actions">',
        '<div class="two fluid ui inverted buttons">',
        '<div class="ui red basic inverted button">',
        'Cancel',
        '</div>',
        '<div class="ui green basic inverted button confirm-modal-delete" data-url="',
        $btn.attr('data-url'),'" data-redirect-url="',$btn.attr('data-redirect-url'),
        '" data-no-redirect="',$btn.attr('data-no-redirect'),
        '" data-container-selector="',$btn.attr('data-container-selector'),'">',
        'Delete',
        '</div></div></div></div>'].join(""));
    }

    var deletionModal = $('#delete-confirm-modal');

    deletionModal.find('.content .description p').text($btn.attr('data-text'));
    confirmDeleteListener();
    // Check if there are sidebars. If there are, close them.
    var $sidebars = $('.ui.sidebar');
    if($sidebars.length > 0){
      $sidebars.sidebar('hide');
    }
    deletionModal.modal('show');
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
    resetForm: resetForm,
    showAndGoToErrors: showAndGoToErrors,
    liveValidateRequiredFields: liveValidateRequiredFields,
    initFormSubmitWithin: initFormSubmitWithin,
    initVerify: initVerify,
    paramsForAjaxSubmit: paramsForAjaxSubmit,
    initAjaxForm: initAjaxForm,
    disableSubmit: disableSubmit,
    resetSubmit: resetSubmit,
    scrollToVerifyErrors: scrollToVerifyErrors
  };
})(jQuery);