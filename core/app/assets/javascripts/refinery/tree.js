$(function() {
  $('.tree .toggle').live('click', function(event) { 
    event.preventDefault(); 
    $(this)
      .toggleClass('expanded')
      .parents('div:first').next('.nested').slideToggle(); 
  }).trigger('click');
});
