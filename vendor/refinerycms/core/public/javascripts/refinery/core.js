$(document).ready(function(){
  // focus first field in an admin form.
  $('form input[type=text]:first').focus();

  init_flash_messages();
});

init_flash_messages = function(){
  $('#flash').css({
    'opacity': 0
    , 'visibility':'visible'
  }).animate({'opacity': '1'}, 550);
  $('#flash_close').click(function(e) {
     $('#flash').animate({'opacity': 0, 'visibility': 'toggle'}, 330);
     e.preventDefault();
  });
  $('#flash.flash_message').prependTo('#records');
};
