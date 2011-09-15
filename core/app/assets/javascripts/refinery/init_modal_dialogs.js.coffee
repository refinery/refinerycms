init_modal_dialogs = ->
  $("a[href*=\"dialog=true\"]").not_("#dialog_container a").each (i, anchor) ->
    $(anchor).data(
      "dialog-width": parseInt($($(anchor).attr("href").match("width=([0-9]*)")).last().get(0), 10) or 928
      "dialog-height": parseInt($($(anchor).attr("href").match("height=([0-9]*)")).last().get(0), 10) or 473
      "dialog-title": ($(anchor).attr("title") or $(anchor).attr("name") or $(anchor).html() or null)
    ).attr("href", $(anchor).attr("href").replace(/(\&(amp\;)?)?dialog\=true/, "").replace(/(\&(amp\;)?)?width\=\d+/, "").replace(/(\&(amp\;)?)?height\=\d+/, "").replace(/(\?&(amp\;)?)/, "?").replace(/\?$/, "")).click (e) ->
      $anchor = $(this)
      iframe_src = (iframe_src = $anchor.attr("href")) + (if iframe_src.indexOf("?") > -1 then "&" else "?") + "app_dialog=true&dialog=true"
      iframe = $("<iframe id='dialog_iframe' frameborder='0' marginheight='0' marginwidth='0' border='0'></iframe>")
      iframe.corner "8px"  unless $.browser.msie
      iframe.dialog 
        title: $anchor.data("dialog-title")
        modal: true
        resizable: false
        autoOpen: true
        width: $anchor.data("dialog-width")
        height: $anchor.data("dialog-height")
        open: onOpenDialog
        close: onCloseDialog
      
      iframe.attr "src", iframe_src
      e.preventDefault()

init_sortable_menu = ->
  $menu = $("#menu")
  return  if $menu.length == 0
  $menu.sortable(
    axis: "x"
    cursor: "crosshair"
    connectWith: ".nested"
    update: ->
      $.post "/refinery/update_menu_positions", $menu.sortable("serialize", 
        key: "menu[]"
        expression: /plugin_([\w]*)$/
      )
  ).tabs()
  $menu.sortable "disable"
  $menu.find("#menu_reorder").click (e) ->
    trigger_reordering e, true
  
  $menu.find("#menu_reorder_done").click (e) ->
    trigger_reordering e, false
  
  $menu.find("> a").corner "top 5px"

trigger_reordering = (e, enable) ->
  e.preventDefault()
  $("#menu_reorder, #menu_reorder_done").toggle()
  $("#site_bar, #content").fadeTo 500, (if enable then 0.35 else 1)
  if enable
    $menu.find(".tab a").click (ev) ->
      ev.preventDefault()
  else
    $menu.find(".tab a").unbind "click"
  $menu.sortable (if enable then "enable" else "disable")

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
  $("#continue_editing").val true
  $("#flash").fadeOut 250
  $(".fieldWithErrors").removeClass("fieldWithErrors").addClass "field"
  $("#flash_container .errorExplanation").remove()
  $.post $("#continue_editing").get(0).form.action, $($("#continue_editing").get(0).form).serialize(), (data) ->
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
      $("#continue_editing").val false
      init_flash_messages()
  
  e.preventDefault()
