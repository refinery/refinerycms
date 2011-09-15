init_submit_continue = function(){
  $('#submit_continue_button').click(submit_and_continue);

  $('form').change(function(e) {
    $(this).attr('data-changes-made', true);
  });

  if ((continue_editing_button = $('#continue_editing')).length > 0 && continue_editing_button.attr('rel') != 'no-prompt') {
    $('#editor_switch a').click(function(e) {
      if ($('form[data-changes-made]').length > 0) {
        if (!confirm(I18n.t('js.admin.confirm_changes'))) {
          e.preventDefault();
        }
      }
    });
  }
};

submit_and_continue = function(e, redirect_to) {
  // ensure wymeditors are up to date.
  if ($(this).hasClass('wymupdate')) {
    $.each(WYMeditor.INSTANCES, function(index, wym)
    {
      wym.update();
    });
  }

  $('#continue_editing').val(true);
  $('#flash').fadeOut(250);

  $('.fieldWithErrors').removeClass('fieldWithErrors').addClass('field');
  $('#flash_container .errorExplanation').remove();

  $.post($('#continue_editing').get(0).form.action, $($('#continue_editing').get(0).form).serialize(), function(data) {
    if (($flash_container = $('#flash_container')).length > 0) {
      $flash_container.html(data);

      $('#flash').css({'width': 'auto', 'visibility': null}).fadeIn(550);

      $('.errorExplanation').not($('#flash_container .errorExplanation')).remove();

      if ((error_fields = $('#fieldsWithErrors').val()) != null) {
        $.each(error_fields.split(','), function() {
          $("#" + this).wrap("<div class='fieldWithErrors' />");
        });
      } else if (redirect_to) {
        window.location = redirect_to;
      }

      $('.fieldWithErrors:first :input:first').focus();

      $('#continue_editing').val(false);

      init_flash_messages();
    }
  });

  e.preventDefault();
};
