window.init_ajaxy_pagination = function() {
  if (typeof window.history.pushState === "function") {
    $(".pagination_container .pagination a").on("click", function(e) {
      let navigate_to = this.href.replace(/(\&(amp\;)?)?from_page\=\d+/, "");
      navigate_to += "&from_page=" + $(".current").text();
      navigate_to = navigate_to.replace("?&", "?").replace(/\s+/, "");
      
      const current_state_location = location.pathname + location.href.split(location.pathname)[1];
      
      window.history.pushState({ path: current_state_location }, "", navigate_to);
      $(document).paginateTo(navigate_to);
      
      e.preventDefault();
    });
  }
};