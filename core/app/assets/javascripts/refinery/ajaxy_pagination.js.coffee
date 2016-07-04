@init_ajaxy_pagination = ->
  if typeof (window.history.pushState) == "function" and $(".pagination_container").length > 0
    pagination_pages = $(".pagination_container .pagination a")
    pagination_pages.live "click", (e) ->
      $(document).paginateTo navigate_to(this)
      e.preventDefault()
  $(".pagination_container").applyMinimumHeightFromChildren()
  $(".pagination_frame").css "top", "0px"  if $(".pagination_container").find(".pagination").length == 0

@navigate_to = (link)->
  path = link.href.replace(/(\&(amp\;)?)?from_page\=\d+/, "")
  path += "&from_page=" + $(".current").text()
  path = path.replace("?&", "?").replace(/\s+/, "")
  current_state_location = (location.pathname + location.href.split(location.pathname)[1])
  window.history.pushState path: current_state_location, "", path
  return path

