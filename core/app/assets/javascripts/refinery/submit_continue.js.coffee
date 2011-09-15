init_submit_continue = () ->
  $('#submit_continue_button').click ->
    submit_and_continue
   $('form').change (e) ->
     $(this).attr('data-changes-made', true)

    if (continue_editing_button = $('#continue_editing')).length > 0 and continue_editing_button.attr('rel') != 'no-prompt' then
    $('#editor_switch a').click (e) ->
      if $('form[data-changes-made]').length > 0
        if not confirm(I18n.t('js.admin.confirm_changes'))
          e.preventDefault()

submit_and_continue = (e, redirect_to) ->
  # ensure wymeditors are up to date.
  if $(this).hasClass('wymupdate') 
    $.each (WYMeditor.INSTANCES), (index, wym) -> $.each (WYMeditor.INSTANCES), (index, wym) ->
      wym.update()

  $continue_editing = $('#continue_editing') 
  $continue_editing.val(true)
  $('#flash').fadeOut(250)

  $('.fieldWithErrors').removeClass('fieldWithErrors').addClass('field')
  $('#flash_container .errorExplanation').remove()

  $.post($continue_editing.get(0).form.action, $($continue_editing.get(0).form).serialize(), data) ->
    if (($flash_container = $('#flash_container')).length > 0)
      $flash_container.html(data)
      $('#flash').css({'width': 'auto', 'visibility': null}).fadeIn(550)
      $('.errorExplanation').not($('#flash_container .errorExplanation')).remove()

    if (error_fields = $('#fieldsWithErrors').val()) != null
      $.each(error_fields.split(',')) ->
        $("#" + this).wrap("<div class='fieldWithErrors' />")
    else if(redirect_to) 
      window.location = redirect_to

      $('.fieldWithErrors:first :input:first').focus()

      $('#continue_editing').val(false)

      init_flash_messages()
    
  e.preventDefault()
