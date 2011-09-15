init_submit_continue = ->
  $("#submit_continue_button").click submit_and_continue
  $("form").change (e) ->
    $(this).attr "data-changes-made", true
  
  if (continue_editing_button = $("#continue_editing")).length > 0 and continue_editing_button.attr("rel") != "no-prompt"
    $("#editor_switch a").click (e) ->
      e.preventDefault()  unless confirm(I18n.t("js.admin.confirm_changes"))  if $("form[data-changes-made]").length > 0

submit_and_continue = (e, redirect_to) ->
  if $(this).hasClass("wymupdate")
    $.each WYMeditor.INSTANCES, (index, wym) ->
      wym.update()
  $continue_editing = $('#continue_editing')
  $continue_editing.val true
  $("#flash").fadeOut 250
  $(".fieldWithErrors").removeClass("fieldWithErrors").addClass "field"
  $("#flash_container .errorExplanation").remove()
  $.post $continue_editing.get(0).form.action, $($continue_editing.get(0).form).serialize(), (data) ->
    if ($flash_container = $("#flash_container")).length > 0
      $flash_container.html data
      $("#flash").css(
        width: "auto"
        visibility: null
      ).fadeIn 550
      $(".errorExplanation").not_($("#flash_container .errorExplanation")).remove()
      if (error_fields = $("#fieldsWithErrors").val())?
        $.each error_fields.split(","), ->
          $("#" + this).wrap "<div class='fieldWithErrors' />"
      else window.location = redirect_to  if redirect_to
      $(".fieldWithErrors:first :input:first").focus()
      $continue_editing.val false
      init_flash_messages()
  
  e.preventDefault()
