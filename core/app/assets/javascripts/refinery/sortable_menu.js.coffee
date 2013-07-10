@init_sortable_menu = ->
  $menu = $("#menu")
  return  if $menu.length == 0
  $menu.sortable(
    items: "> *:not(#menu_reorder, #menu_reorder_done)"
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
  ###
  $menu.find("> a").corner "top 5px"
  ###