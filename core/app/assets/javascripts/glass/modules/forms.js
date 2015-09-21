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

        //Might be tempting to put this in beforeSubmit... but DON'T (timing issue)
        $form.trigger('form-before-submit');
        return true;
      });

      $form.ajaxForm({
        dataType: 'json',
        beforeSubmit: function(arr, $form, options){
          disableSubmit($form);
        },

        success: function(e, response, statusText, xhr, element) {
          $form.trigger('form-submit-success', [e, response, statusText, xhr, element]);
        },

        complete: function (xhr, status) {
          if ($form.hasClass('mailchimp')) {
            $form.find('input[type="email"]').val('Thank you!');
            return;
          }

          var replace_selector = $form.data('ajax-replace-selector');
          var callback = $form.data('on-complete-callback');
          var $replace_form; // if the same form that was submitted is in response, replace it
          var $callback_param;

          $form.data('redirect-on-success', true);

          if (xhr.responseJSON) {
            $callback_param = xhr.responseJSON;
          }
          else {
            $replace_form = replace_selector ? $(xhr.responseText).find(replace_selector) : $(xhr.responseText).find(selector);
            $callback_param = $replace_form;
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

          if (xhr.responseJSON) {
            var message = xhr.responseJSON.message === undefined ? 'Unknown Error' : xhr.responseJSON.message;

            if (xhr.status == 200) {
              handleSuccess($form, $("<p>" + message + "</p>"));
            }
            else {
              insertErrors($form, xhr.responseJSON.errors === undefined ? message : xhr.responseJSON.errors, null);
            }
          }
          else if (xhr.responseText) {
            var $page_body      = $(xhr.responseText).find('#body_content, .glass-edit-html'); // if response is a page, use inner content
            var $error_response = ($(xhr.responseText).attr('id') === 'errorExplanation') ? $(xhr.responseText) : $replace_form.find('#errorExplanation');

            if ($error_response.length > 0 && $error_response.hasClass('active')) {
              insertErrors($form, $error_response, null);
            }
            else {
              var $replacement = null;

              if ($replace_form.length > 0) {
                $replacement = $replace_form;
              }
              else if ($page_body.length > 0) {
                $replacement = $page_body.first();
              } else {
                $replacement = $('<p>Thank you</p>'); // Default response message
              }

              handleSuccess($form, $replacement);
            }
          }

          resetSubmit($form);
        }
      });
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

  function handleSuccess($form, $replacement) {
    var $submit_btn      = $form.data("submit-btn");
    var $modal           = $form.parents('.modal');
    $form.find('.errorExplanation').addClass('hidden');

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
    liveValidateRequiredFields: liveValidateRequiredFields,
    initFormSubmitWithin: initFormSubmitWithin,
    initVerify: initVerify,
    initAjaxForm: initAjaxForm,
    disableSubmit: disableSubmit,
    resetSubmit: resetSubmit,
    scrollToVerifyErrors: scrollToVerifyErrors
  };
})(jQuery);
