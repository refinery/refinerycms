$(document).ready(function(){
  // focus first field in an admin form.
  $('form input[type=text]:first').focus();

  init_flash_messages();
});

init_flash_messages = function() {

  $('#flash_container').on('click', '#flash_close', function(e) {
    $('#flash').hide();
    e.preventDefault();
  });
  $('#flash.flash_message').prependTo('#records');
};
