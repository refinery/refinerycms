$(document).ready(function(){
  init_flash_messages();
});

init_flash_messages = function(){
  $('#flash').fadeIn(550);
  $('#flash_close').click(function(e) {
     $('#flash').fadeOut({duration: 330});
     e.preventDefault();
  });
  $('#flash.flash_message').prependTo('#records');
}