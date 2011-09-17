@init_tooltips = (args) ->
  $($((if args? then args else "a[title], span[title], #image_grid img[title], *[tooltip]"))).not_(".no-tooltip").each (index, element) ->
    $(element).hover((e) ->
      if e.type == "mouseenter" or e.type == "mouseover"
        $(this).oneTime 350, "tooltip", $.proxy(->
          $(".tooltip").remove()
          tooltip = $("<div class='tooltip'><div><span></span></div></div>").appendTo("#tooltip_container")
          tooltip.find("span").html $(this).attr("tooltip")
          tooltip.corner("6px").find("span").corner "6px"  unless $.browser.msie
          tooltip_nib_image = (if $.browser.msie then "tooltip-nib.gif" else "tooltip-nib.png")
          nib = $("<img src='/assets/refinery/" + tooltip_nib_image + "' class='tooltip-nib'/>").appendTo("#tooltip_container")
          tooltip.css 
            opacity: 0
            maxWidth: "300px"
          
          required_left_offset = $(this).offset().left - (tooltip.outerWidth() / 2) + ($(this).outerWidth() / 2)
          tooltip.css "left", (if required_left_offset > 0 then required_left_offset else 0)
          tooltip_offset = tooltip.offset()
          tooltip_outer_width = tooltip.outerWidth()
          tooltip.css "left", window_width - tooltip_outer_width  if tooltip_offset and (tooltip_offset.left + tooltip_outer_width) > (window_width = $(window).width())
          tooltip.css top: $(this).offset().top - tooltip.outerHeight() - 10
          nib.css opacity: 0
          if tooltip_offset = tooltip.offset()
            nib.css 
              left: $(this).offset().left + ($(this).outerWidth() / 2) - 5
              top: tooltip_offset.top + tooltip.height()
          try
            tooltip.animate 
              top: tooltip_offset.top - 10
              opacity: 1
            , 200, "swing"
            nib.animate 
              top: nib.offset().top - 10
              opacity: 1
            , 200
          catch e
            tooltip.show()
            nib.show()
        , $(this))
      else if e.type == "mouseleave" or e.type == "mouseout"
        $(this).stopTime "tooltip"
        unless (tt_offset = (tooltip = $(".tooltip")).css("z-index", "-1").offset())?
          tt_offset = 
            top: 0
            left: 0
        tooltip.animate 
          top: tt_offset.top - 20
          opacity: 0
        , 125, "swing", ->
          $(this).remove()
        
        unless (nib_offset = (nib = $(".tooltip-nib")).offset())?
          nib_offset = 
            top: 0
            left: 0
        nib.animate 
          top: nib_offset.top - 20
          opacity: 0
        , 125, "swing", ->
          $(this).remove()
    ).click (e) ->
      $(this).stopTime "tooltip"
    
    $(element).attr "tooltip", $(element).attr("title")  unless $(element).attr("tooltip")?
    $elements = $(element).add($(element).children("img")).removeAttr("title")
    $elements.removeAttr "alt"  if $.browser.msie
